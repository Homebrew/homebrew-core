class Dot < Formula
  desc "Yet another management tool for dotfiles"
  homepage "https://github.com/ubnt-intrepid/dot"
  url "https://github.com/ubnt-intrepid/dot/archive/v0.1.4.tar.gz"
  sha256 "7f043f5a0e59b08f36c98e7117a65e5bbfdc927b0b55103e8de0cad5c94d6c1b"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "dot", "root"
  end
end
