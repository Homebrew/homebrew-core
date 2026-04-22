class Passwdqc < Formula
  desc "Password/passphrase strength checking and enforcement toolset"
  homepage "https://www.openwall.com/passwdqc/"
  url "https://www.openwall.com/passwdqc/passwdqc-2.1.0.tar.gz"
  sha256 "52fa12271104e74126145c6224b22b4a8dd32cc47de04c1e9fb8f348340df4d2"
  license "0BSD"

  livecheck do
    url :homepage
    regex(/href=["']?passwdqc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0a349bcdec4b9b3e296e049c663627a1752f883cf9e3755dc5ced053d8c690c"
    sha256 cellar: :any,                 arm64_sequoia: "ee5a3b9c40125c1dad4ee7a35b35322b584d746956e76a9165e07c8da57f26ad"
    sha256 cellar: :any,                 arm64_sonoma:  "c0e97c2f7b405e60ac8e170e03c52165806b7d7dbac5d2024c66ac285440c603"
    sha256 cellar: :any,                 sonoma:        "c050f0ad30305987658735042a78c40f08c60c794446ecca0c5a95e453ee9df8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11a48ec53400c8768ef9e9848e76db6cafaa6a6e42e76ad96c0d651d2e7c6770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66fe79676d2ee8d4d1daf551806371f54e83facac4c7941fa9d0e743d944d48a"
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "linux-pam"
  end

  def install
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

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    args << "CFLAGS=#{ENV.cflags}" if ENV.cflags.present?

    system "make", *args
    system "make", "install", *args
  end

  test do
    pipe_output("#{bin}/pwqcheck -1", shell_output("#{bin}/pwqgen"))
  end
end
