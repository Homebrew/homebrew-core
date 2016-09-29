class Dsh < Formula
  desc "Dancer's shell, or distributed shell"
  homepage "https://www.netfort.gr.jp/~dancer/software/dsh.html.en"
  url "https://www.netfort.gr.jp/~dancer/software/downloads/dsh-0.25.9.tar.gz"
  sha256 "147c59c902dbd7a3290e20f41b5cc594192d6c93957d34dd061eb8d27bd9e466"

  bottle do
    sha256 "b9f958c1595b577fbe386d96a8dec6fbbb518792ba78b1d689598b6bd3cd53bb" => :sierra
    sha256 "7bf6d4a1c75260ab37c82122f793be6270c98b50d95773e58ee83b26e8e5cd6f" => :el_capitan
    sha256 "057887c4fb924646aa71dde1264a7030ecbf7d0a8d1d57e6c008a6887b03d46e" => :yosemite
    sha256 "15918191492c128f41f7182084bcd051bf9d12472bba59725bd510a35e8f447f" => :mavericks
  end

  depends_on "libdshconfig"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
