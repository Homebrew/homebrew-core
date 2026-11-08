class Knife < Formula
  desc "Reverse engineering toolkit for PE, ELF, and Mach-O binaries"
  homepage "https://github.com/bl4ckr0ss3/knife"
  url "https://github.com/bl4ckr0ss3/knife/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "822e3f48a8d7986d0ae17bd47be183884ca414195ead205823d0825d826d6062"
  license "MIT"
  head "https://github.com/bl4ckr0ss3/knife.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"knife", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/knife --version")

    (testpath/"sample.bin").binwrite("\x00Homebrew sandbox test\x00")
    output = shell_output("#{bin}/knife strings --json #{testpath}/sample.bin")
    assert_equal ["Homebrew sandbox test"], JSON.parse(output)
  end
end
