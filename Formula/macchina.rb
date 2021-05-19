class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v0.8.1.tar.gz"
  sha256 "21ecc57ecc0f13bdb438d8ec78d3f630084cae7a4b69eea66e8f3ce18b5ab2f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7be0fa31c72dc280fc861bc8c868d403a71cb3142bb984fb8f936104fc3aa795"
    sha256 cellar: :any_skip_relocation, big_sur:       "0f452397c12728d9c3b70628313cc7ccaa019bbf33c64ee18e102562bff1abd4"
    sha256 cellar: :any_skip_relocation, catalina:      "733627a56457de483ce7ecb2d0476bf2ec8bc83396a21310978d07b221ff54c5"
    sha256 cellar: :any_skip_relocation, mojave:        "0d313074c526c1ad2e91f77c6af7d5541ab201e773d41128c9f3dd9f79d4e448"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
