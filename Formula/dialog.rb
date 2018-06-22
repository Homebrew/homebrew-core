class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20180621.tgz"
  sha256 "4a4859e2b22d24e46c1a529b5a5605b95503aa04da4432f7bbd713e3e867587a"

  bottle do
    cellar :any_skip_relocation
    sha256 "0168f1b0060b33b57099f1dc5412d84620b6ae27a23c80ba0b7c8d8c7a6045ac" => :high_sierra
    sha256 "16dcced9f6ffc983ce1aea72b562aae09fce59f9b380e9b593e03759e2e79537" => :sierra
    sha256 "8d55d6e400627561189a0fb9785ae8e9d6fdc79ed81337edb9a4bd9a07d42a61" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
