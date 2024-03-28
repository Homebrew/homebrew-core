class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.124.1",
      revision: "db083b05f16c945fec04f745f0ca8640560cf1ec"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "622a16859693f485711b148e20517358436da479b0f0b27ff5dc15464959ffc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53b008c0ba1cbdfbdea93938bd42a0f448a5ce98ee295be9155b18fca6c3c4c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "551993e40029b6d0e92fe9d2bc8dec37815343a1365345a2ae993b7d9ddbe0c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee698f6a66db517cb670e69d0b033eda11cb4e063308ebd0207bb91769ae33c9"
    sha256 cellar: :any_skip_relocation, ventura:        "ddaf3c5b3b3ddbcff797ee36abca0a8700ac18c1562d8c1d58217875898f6df3"
    sha256 cellar: :any_skip_relocation, monterey:       "7038cb387d117ee5212f440e64728df8c28aa2b7b81c439e61419aa9229618a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9ed95addfc5874a54f05242e770038ad5fc7b88bec4703fac2e99d68275e03a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{Utils.git_head}
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
