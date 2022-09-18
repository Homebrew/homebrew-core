class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v6.1.5.tar.gz"
  sha256 "0df28be92649746ebe4dec13c1a4f95e877cea2ece8ee463e836c0004555248d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aed5b2237930c0ef57375e0ff4b99c5e4c47d42de33a4f72d599328e2149acd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2521b8c324b6c2a72b2935482ec8b9dc7087e16ff5ebf7a8d58989820a3972b"
    sha256 cellar: :any_skip_relocation, monterey:       "e618e1161ac059be8e9eeb478a644376eb153e90606d769088e980fe24a23d0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "89b8de0ecd2f9f81f4ce66a6781751d894c12fbbf29376d2600367c558870749"
    sha256 cellar: :any_skip_relocation, catalina:       "d82b9f0afb9aa2358695f5631c079a87316dba692a5ea74a7bb656412abe3d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd33696667b3265736be0f6603e0f2939ae2ba14d8fe9de22183b191debf535a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
