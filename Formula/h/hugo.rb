class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.146.3.tar.gz"
  sha256 "e1655436e5bb592964870121693238e223474f810e443434174a0fc77682801f"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9ae2fe88e39728f98e290674f30d7d0e80cc7095507f8739982572c14df52c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7291edc37f3317afaca20413e2c2346672d4e68201bb520ee6eb352d3a9b3686"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9592258a71e56126e1ca7256af4d4ee71059ee13cbfcac6f0540f4cd543e15d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3b433bd085ecda00d2375d6dbbf34906a47261bc94f6070d026a60e31dfb319"
    sha256 cellar: :any_skip_relocation, ventura:       "45e489783aded7531853961b8826c20b7d558dc5047566b1582e809c2dfaf043"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4685c9e883e7daa70ee142cbb104934a9a1db1410da578481660ab1b94c01db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01f58cef8cd8ba1c5ed88370ecd4f480642e19bc1c77e3611c9e42e438891fd5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
