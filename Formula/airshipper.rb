class Airshipper < Formula
  desc "Launcher for Veloren, a multiplayer voxel RPG"
  homepage "https://veloren.net"
  url "https://gitlab.com/veloren/airshipper/-/archive/v0.7.0/airshipper-v0.7.0.tar.gz"
  sha256 "dd68535fe6a7a4f01186b590c33e7b12bc79c8aa8a96529e22f9321ea2a06325"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build

  on_linux do
    depends_on "libxkbcommon"
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "client")
    system "cargo", "install", *std_cargo_args(path: "server")
  end

  test do
    assert_match "Done", shell_output("#{bin}/airshipper update")
  end
end
