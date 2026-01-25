class Nbping < Formula
  desc "Ping Tool in Rust with Real-Time Data and Visualizations"
  homepage "https://github.com/hanshuaikang/Nping"
  url "https://github.com/hanshuaikang/Nping/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "48d46e11cec3c69e6c28e91fefbba47f4773aab1c9d8c1f15e276311f79c43ec"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "nbping v#{version}", shell_output("#{bin}/nbping --version")

    # Fails in Linux CI with "No such device or address (os error 2)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"nbping", "--count", "2", "brew.sh"
  end
end
