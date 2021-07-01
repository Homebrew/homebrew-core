class Drg < Formula
  desc "Command-line tool for managing apps and devices in drogue cloud"
  homepage "https://drogue.io"
  url "https://github.com/drogue-iot/drg/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "29f8d8adb014da9a47b1e68d485dedc180621844e7af228bc88a2cfb34baca63"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/drg", "--version"
  end
end
