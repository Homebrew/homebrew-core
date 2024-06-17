class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.127.0.tar.gz"
  sha256 "549c7ebdf2ee6b3107ea10a9fbd9932a91bb3f30f7e8839245f6d8e318aca88c"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c516b0f741b2cf2643c180309f550794040e3462216ed3a841ce4429eeda9b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eac59f1eb54ce115bf9d40b757a46e5feb9edc47c1b16b3585d3893b5f6d6fa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aac003394c174a7651eeed6bf80a994a4631f95efd902414a29cfe2e5125ba00"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c0a702416fcb4b0cc19416fceaa5210c76d829dd41d47fb63e79fad5aab7a2c"
    sha256 cellar: :any_skip_relocation, ventura:        "01e773849806f1531d107be5841d4d5fd6dfd821123e6e2921a88b9e1e6686d4"
    sha256 cellar: :any_skip_relocation, monterey:       "0e7c6ec1647d729e1b9df03cd65a01f61250f8d097721df625468b38bdbfaa82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2732b651f9f4cd8dd7b3b2a34e30d1beea047c2bd9b762f4b03b68e1280ec2d4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended"

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
