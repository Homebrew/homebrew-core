class Feishu2md < Formula
  desc "Convert feishu/larksuite documents to markdown"
  homepage "https://github.com/Wsine/feishu2md"
  url "https://github.com/Wsine/feishu2md/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "ba4efca5bda10f46ca243e961e314f80532ad8533caf742521250e1bc677f74a"
  license "MIT"
  head "https://github.com/Wsine/feishu2md.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82204b6c9dd00fb608a7614dc617780425daa713056ef59387d3d870e23d65a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82204b6c9dd00fb608a7614dc617780425daa713056ef59387d3d870e23d65a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82204b6c9dd00fb608a7614dc617780425daa713056ef59387d3d870e23d65a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a95e2b53c60de61472fc0f76ad47213d90385c104f9c6d89ad8d029d7f9e08d"
    sha256 cellar: :any_skip_relocation, ventura:       "0a95e2b53c60de61472fc0f76ad47213d90385c104f9c6d89ad8d029d7f9e08d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db49c3b5b879ef0e64fc72bda13d1c15429e54eae26754a7891b10e8940d1f8c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    output = shell_output("#{bin}/feishu2md config --appId testAppId --appSecret testSecret")
    assert_match "testAppId", output

    assert_match version.to_s, shell_output("#{bin}/feishu2md --version")
  end
end
