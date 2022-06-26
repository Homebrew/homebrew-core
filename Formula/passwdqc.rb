class Passwdqc < Formula
  desc "Password/passphrase strength checking and enforcement toolset"
  homepage "https://www.openwall.com/passwdqc/"
  url "https://www.openwall.com/passwdqc/passwdqc-2.0.2.tar.gz"
  sha256 "ff1f505764c020f6a4484b1e0cc4fdbf2e3f71b522926d90b4709104ca0604ab"
  license "0BSD"
  revision 1

  livecheck do
    url :homepage
    regex(/href=["']?passwdqc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "99f35fd4dbbf9d0db3457053c5b6b71ca38e6b92dfdfc638605ee363cb523f76"
    sha256 cellar: :any,                 arm64_big_sur:  "87c91a50483dfd61f66542a498b5b6ecee337d6a8863c8e106d1609c4ff22770"
    sha256 cellar: :any,                 monterey:       "a3ddd06589d1ad2f58c734283893b3584209bf65c78892646f59a49a2ded4bf5"
    sha256 cellar: :any,                 big_sur:        "2ac0e69fcc86d824ccb4713121f4729bf49964fa27504a00af4bc7ed912063d8"
    sha256 cellar: :any,                 catalina:       "6d317c9e9f66aee1fb49c921b8e8876b45321099e6cc7be40c8ee1340585a647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3a1fcb790a85274c58bf098b5d4c5a60f70c3b93dbb069eb1fd6e13c75c1b92"
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    # https://github.com/openwall/passwdqc/issues/15
    inreplace "passwdqc_filter.h", "<endian.h>", "<machine/endian.h>" if OS.mac?

    args = %W[
      BINDIR=#{bin}
      CC=#{ENV.cc}
      CONFDIR=#{etc}
      DEVEL_LIBDIR=#{lib}
      INCLUDEDIR=#{include}
      MANDIR=#{man}
      PREFIX=#{prefix}
      SHARED_LIBDIR=#{lib}
    ]

    args << if OS.mac?
      "SECUREDIR_DARWIN=#{prefix}/pam"
    else
      "SECUREDIR=#{prefix}/pam"
    end

    system "make", *args
    system "make", "install", *args
  end

  test do
    pipe_output("#{bin}/pwqcheck -1", shell_output("#{bin}/pwqgen"))
  end
end
