class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.136.2.tar.gz"
  sha256 "ca8ba334a181fe257bfc94e700aed7c514acf6898ad2f861d57d8702cd19e0df"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f791db49e92f063dcc20bbb063536bb62a6d67d59c559a71153edb83b4180db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "767ee709af491752b04a713ea8e2692ed7e0970940c5154bd7b97a3eb9edde38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9a10dbccb8e5bd731dcbd19f41f4dc25e948ce4f7511b6c8c2680a108f486f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fff1033b3557b0dea5c23132179c8c783aa2a4bd6cf8a4f7d573c7ceed52a3b0"
    sha256 cellar: :any_skip_relocation, ventura:       "037436c561a1e43d98cee167fcee0b03de8b0e9fc54ebeed05d78e210eaa5f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fc3d17f5b25dd8c21ae93fddf7ebcd973cb94ef1fa7c6295de858e999fdf822"
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
