class Cntlm < Formula
  desc "NTLM authentication proxy with tunneling"
  homepage "https://cntlm.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3.tar.bz2"
  sha256 "7b603d6200ab0b26034e9e200fab949cc0a8e5fdd4df2c80b8fc5b1c37e7b930"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/cntlm[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 arm64_ventura:  "f4674d812c8b17f3e78bea4dfd0bccf3149de7c0be14f9027d2f07724f3eaf32"
    sha256 arm64_monterey: "ec776bb3b8bd91670fdf97e67fefc1ae8c2a4f2901cbb2b007622d22b8e697d7"
    sha256 arm64_big_sur:  "edfcd9088709ea81afc22ec95e7fc9e3c2707dfbcf25582955af0d6288dc4d11"
    sha256 ventura:        "3bb0d9bd593c362c6303a22d404efc85a9ffcc648110808b3271654574326284"
    sha256 monterey:       "473e65aea1b1536ccbd7390fa121cf0273f47c0184b08bf0398d28aa0e128e92"
    sha256 big_sur:        "fccbf3803f9aff9aa6b0bb9b8f0e17c28b80e1b85ef0d712082744bdd417eda9"
    sha256 catalina:       "7239fa52155edd2040ed7bff62b954351bb5e96fd226b4f0e1f7e956c64223d7"
    sha256 mojave:         "79b1221fa60196d7670bb3cbcd6bab63490ba780222e7faf84404a57ac52d6ba"
    sha256 high_sierra:    "9a1bafd1930ba3ade9b8df892d9fd28a0c414750ee728a791886dd9c999d0173"
    sha256 x86_64_linux:   "523184cb07c5b9c17d65a2a36f767ed37726570ec5ac3239ae49be84e12c5f6b"
  end

  def install
    system "./configure"
    system "make", "CC=#{ENV.cc}", "SYSCONFDIR=#{etc}"
    # install target fails - @adamv
    bin.install "cntlm"
    man1.install "doc/cntlm.1"
    etc.install "doc/cntlm.conf"
  end

  def caveats
    "Edit #{etc}/cntlm.conf to configure Cntlm"
  end

  plist_options startup: true

  service do
    run [opt_bin/"cntlm", "-f"]
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/cntlm -h 2>&1", 1)

    bind_port = free_port
    (testpath/"cntlm.conf").write <<~EOS
      # Cntlm Authentication Proxy Configuration
      Username	testuser
      Domain		corp-uk
      Password	password
      Proxy		localhost:#{free_port}
      NoProxy		localhost, 127.0.0.*, 10.*, 192.168.*
      Listen		#{bind_port}
    EOS

    fork do
      exec "#{bin}/cntlm -c #{testpath}/cntlm.conf -v"
    end
    sleep 2
    assert_match "502 Parent proxy unreacheable", shell_output("curl -s localhost:#{bind_port}")
  end
end
