class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.123.3",
      revision: "a75a659f6fc0cb3a52b2b2ba666a81f79a459376"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d4cf42535f29f95b547308f811be02f88adb40065bdffdaf23807bf78449567"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85ef4e1db4996a1508b01c4f253f2c7ab70d6e8db29105918aa0ea6412b2a378"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d48dc69ec9c7bea03098f89ddd27e348bd0e8fe08ec5abcc19afd71e5173f987"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0b62cbca0c8a77911e0987312c3811f58f7398a2b43d5c1e90232d595bf0044"
    sha256 cellar: :any_skip_relocation, ventura:        "4ba8feda1b6e0e9651e337149edd9aad84420dd71a2feb36a25bc559754f352d"
    sha256 cellar: :any_skip_relocation, monterey:       "9be7825bf59d20667b3aca393e102baa496d830d11d10c57d09f50d492340871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b07c2413220420101a88d18fcc3dc651e819b05e7098f6c97e1bec73c439911"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{Utils.git_head}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
