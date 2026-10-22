class Maclean < Formula
  desc "Free & open-source macOS disk cleaner CLI for developers (Rust)"
  homepage "https://github.com/jamesfeng2009/maclean"
  url "https://github.com/jamesfeng2009/maclean/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "286a9a419a9d92c0cf5a7b2b64db6392b275a04857848c38dc5e5813fde7b7d1"
  license "Apache-2.0"

  depends_on :macos
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "apps/maclean-cli"
  end

  test do
    assert_match "maclean", shell_output("#{bin}/maclean --version")
  end
end
