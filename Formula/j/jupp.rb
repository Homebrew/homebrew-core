class Jupp < Formula
  desc "Professional screen editor for programmers"
  homepage "http://www.mirbsd.org/jupp.htm"
  url "http://www.mirbsd.org/MirOS/dist/jupp/joe-3.1jupp41.tgz"
  version "3.1jupp41"
  sha256 "7bb8ea8af519befefff93ec3c9e32108d7f2b83216c9bc7b01aef5098861c82f"
  license "GPL-1.0-or-later"
  # Upstream HEAD in CVS: http://www.mirbsd.org/cvs.cgi/contrib/code/jupp/

  livecheck do
    url :homepage
    regex(/href=.*?joe[._-]v?(\d+(?:\.\d+)+jupp\d+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "69af220c327528966dd893daab6d625a5b5241b9273f7b53decb37c5f1e33efe"
    sha256 arm64_sonoma:   "501d87f4b79bf8ae4a8a67b811fbca484e6bc68f6b1e04d9abfb0b1948430880"
    sha256 arm64_ventura:  "821daf3c2f840c5a9942de15a4b0c226928e35808079db3f0d48e686a474f08d"
    sha256 arm64_monterey: "b5732141fc6bfe41e312ee4492c2680a3dcfba4a3951c8f6ab590b2e6c887a01"
    sha256 arm64_big_sur:  "f50e0562ad9f204659b90c6fe30d96708bcb59100e049770ca1da0c8668ebf0a"
    sha256 sonoma:         "67aeb4c92738d070ab3401d6282d122a95a257a0c6d5572a6da184764a2018ab"
    sha256 ventura:        "df22aefb2425b9730ca87ff48af85ef2a6660e8b2e6e6d8c68be5a20690553e7"
    sha256 monterey:       "d4a1370a276e3e6dbe6194ec7d99a488cf79e9a03e7bdef06a347c9210c4f365"
    sha256 big_sur:        "c2666e8966b8fc4322e70d4b5ccfe363b30ebb0166fc619cc354214bad9718f1"
    sha256 x86_64_linux:   "903a19653cafcf340fce69eff4be1d4a5574dde54d87c5934aa269cb25050311"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  conflicts_with "joe", because: "both install the same binaries"

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin" if OS.mac?
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--enable-sysconfjoesubdir=/jupp", *std_configure_args
    system "make", "install"
  end

  test do
    require "pty"
    output = ""
    PTY.spawn({ "TERM" => "xterm" }, bin/"jupp", "test") do |r, w, _pid|
      w.write "brewx"
      begin
        r.each { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match "File test saved", output
    assert_equal "brew", (testpath/"test").read
  end
end
