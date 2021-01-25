class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://github.com/passcod/cargo-watch"
  url "https://github.com/passcod/cargo-watch/archive/v7.5.0.tar.gz"
  sha256 "0d26b2c714f8e02ae4c7a1c4f87496e979694ab7847d3b74959c0d15c92f70ef"
  license "CC0-1.0"
  head "https://github.com/passcod/cargo-watch.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f6e28b4b5ddd527bd9c14ab5361714c1ab126151bf30dc3a253f7d657d2013df" => :big_sur
    sha256 "c108df77dabba1f731c31936a0c68dd75d46fd789073845a844a6c2d8a2e51ad" => :arm64_big_sur
    sha256 "48f1ccc2ad40ecb371b3ff5873be8cc3bac97eb7a99bdf2a5f3dab51585f76ef" => :catalina
    sha256 "7cf3bec869b3b44f1b76d1b97016760519fcdf966f7209b998f1330ce1836b70" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: Not a Cargo project, aborting.", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end
