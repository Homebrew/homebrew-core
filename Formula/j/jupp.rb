class Jupp < Formula
  desc "Professional screen editor for programmers"
  homepage "https://mbsd.evolvis.org/jupp.htm"
  url "https://mbsd.evolvis.org/MirOS/dist/jupp/joe-3.1jupp41.tgz"
  version "3.1jupp41"
  sha256 "7bb8ea8af519befefff93ec3c9e32108d7f2b83216c9bc7b01aef5098861c82f"
  license "GPL-1.0-or-later"
  # Upstream HEAD in CVS: http://www.mirbsd.org/cvs.cgi/contrib/code/jupp/

  livecheck do
    url :homepage
    regex(/href=.*?joe[._-]v?(\d+(?:\.\d+)+jupp\d+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "a657f7b97ce2a81ca28fa85e4d66f779b9d5c36eeef6a7f21916cadc1ca2fd12"
    sha256 arm64_tahoe:       "9ce260439f94128f52d4dbe25f3e996487635255d9ce292bed9f51b4eefebb06"
    sha256 arm64_sequoia:     "4e6f9df5e42351cb3f393b9d33b52a65a7c2eac52ef34cfc95a90e2e03acdc98"
    sha256 arm64_linux:       "8e1c949763b9ed44586ab9ceba53dc5fc85a8bc48d591fe26e64f073478c0680"
    sha256 x86_64_linux:      "7360bc99630b6f39cf3d3f11ce570df13786326720aaea1cb0f3709388cfb1c4"
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
    # C23 makes `()` mean `(void)`, breaking the K&R-style `jpoly_int` callback typedef
    ENV.append_to_cflags "-std=gnu17"
    ENV.prepend_path "PATH", formula_opt_libexec("gnu-sed")/"gnubin" if OS.mac?
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
