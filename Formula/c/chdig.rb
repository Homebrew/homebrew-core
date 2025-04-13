class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v25.3.1.tar.gz"
  sha256 "69fd0063279d4299d760a43a039ceb70064c0e8f24c9bec57c3924aaadcd4216"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0b6aae807bafef2f9b8c3cc2cac8902c9b940d851eda09e92284b21323d7f3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99944617ef118d2e9a4e68555767e98de81a3975749f4c5a102170ad58f035d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3557f765cf85fefaf43aa5e105046d1c6af9d8a02e4418d71aac39af0ba48cc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b37e7f6058d736a6bdc07cc101e566b558e50362989e6fc55ac516619023af6f"
    sha256 cellar: :any_skip_relocation, ventura:       "8b45e4939a1bc047185558281ff150015ea516db42f8bcbde87640f1bf2ac8e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e86bdd74308556e719d5fd1cbec7b7ee67bb9689cbd24a8de459be632f73de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebb0df2a001498ca8993adcb52d37bfc26057dc9313a6d557cb53c87eae67593"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end
