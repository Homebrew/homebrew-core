class Lux < Formula
  desc "Lux (LUcid eXpect scripting) simplifies test automation and provides an Expect-style execution of commands"
  homepage "https://github.com/hawk/lux"
  url "https://github.com/hawk/lux/archive/lux-1.19.3.tar.gz"
  sha256 "e2dd36275c76a087a4b4577bd056a6928a5e5ba5b00d8c366e2a4f94b16f921e"

  head do
    url "https://github.com/hawk/lux.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  option "without-runpty", "Omit pseudo TTY wrapper"

  depends_on "erlang"
  depends_on "wxmac" => :optional

  def install
    ENV.deparallelize  # if your formula fails when building in parallel

    system "autoconf"
    system "./configure", "--prefix=#{prefix}/lux"
    system "make"

    #system "make", "install"
    system "mkdir -p #{prefix}/lux"
    system "tar cf - * | (cd #{prefix}/lux && tar xf -)"
    system "mkdir -p #{prefix}/bin"
    system "ln -s #{prefix}/lux/bin/lux #{prefix}/bin/lux"
  end

  test do
    system "#{bin}/lux", "--version"
  end
end
