class Bed < Formula
  desc "Binary editor written in Go"
  homepage "https://github.com/itchyny/bed"
  url "https://github.com/itchyny/bed/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "253284d71fb328d521f4e3db5b94cfa977c196030ca867d6764f99c44370ceb3"
  license "MIT"
  head "https://github.com/itchyny/bed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c2364667eb42d8ef6d08d8d1ecda4ac01283c182865a3f1a27d4ac2218b335d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c2364667eb42d8ef6d08d8d1ecda4ac01283c182865a3f1a27d4ac2218b335d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c2364667eb42d8ef6d08d8d1ecda4ac01283c182865a3f1a27d4ac2218b335d"
    sha256 cellar: :any_skip_relocation, sonoma:        "606271733f51efc9b38698c50ea1714433033c4e945bea392a5ad2f5ab9f8f8b"
    sha256 cellar: :any_skip_relocation, ventura:       "606271733f51efc9b38698c50ea1714433033c4e945bea392a5ad2f5ab9f8f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "037bb974d7566422fec95308fb5a766edcbbf041b2079206130f09f26c81bef2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.revision=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bed"
  end

  test do
    # bed is a TUI application
    assert_match version.to_s, shell_output("#{bin}/bed -version")
  end
end
