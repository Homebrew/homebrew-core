class Make < Formula
  desc "Utility for directing compilation"
  homepage "https://www.gnu.org/software/make/"
  url "https://ftpmirror.gnu.org/gnu/make/make-4.4.1.tar.lz"
  mirror "https://ftp.gnu.org/gnu/make/make-4.4.1.tar.lz"
  sha256 "8814ba072182b605d156d7589c19a43b89fc58ea479b9355146160946f8cf6e9"
  license "GPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "c46713c2347b3af91fc3fb41f215f26341fec6df4687af080e55d921858f06d5"
    sha256 arm64_sequoia:  "f361639a5ec1a9355e12f985c511dd6631b6790452a52057032a3a07a690ca4e"
    sha256 arm64_sonoma:   "94377dc5a364da305c75fd7aa923a42897993de9edd1eb074428e13c3f2aaf93"
    sha256 arm64_ventura:  "389fd41ada645cde1c43c97f16fc829c80b2312db9c43f358ce774f19d0130d7"
    sha256 arm64_monterey: "49fa5e3e19d0793bdc32cc453a3c209697553ec1fd92964cfbdaf67c6a72a03f"
    sha256 tahoe:          "2263cf3aeb5e8c74e86594abd12047a7ffbf2894ce6269c8e9c44af7c150181f"
    sha256 sequoia:        "cd86f41f2d02a827e15380a13a055606ba2f61819ad5100e4feba0400ef685a7"
    sha256 sonoma:         "3cc4a3aa1a3fe8ef30b2c7089708c5bdb04be3ae47ebc620f2cfd270941e96f2"
    sha256 ventura:        "e5b435315db19e1634289e888fcbd4282ed985a85591a7bec9661595a091d56f"
    sha256 monterey:       "d6d6e4b66e31ed8499dd7d1fecdc4d33b11af9073d0d884aedf9248bcbe6ac3e"
    sha256 arm64_linux:    "8f7572f0b8e63ba05ce8487f7742bcd815413cdb9803f59e0c276564af36daab"
    sha256 x86_64_linux:   "b9fc9f80dd7f93b1b5eb9545044d6f7b016a372e7b2beb03f3e1a045e701410f"
  end

  head do
    url "https://git.savannah.gnu.org/git/make.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build # for autopoint
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
    depends_on "wget" => :build # used by autopull

    uses_from_macos "m4" => :build

    fails_with :clang # fails with invalid arguments sent to compiler
  end

  def install
    if build.head?
      system "./autopull.sh" # downloads gnulib files from git that autogen.sh needs
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gmake" =>"make"
      (libexec/"gnuman/man1").install_symlink man1/"gmake.1" => "make.1"
    end

    (libexec/"gnubin").install_symlink "../gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "make" has been installed as "gmake".
        If you need to use it as "make", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    (testpath/"Makefile").write <<~MAKE
      default:
      	@echo Homebrew
    MAKE

    if OS.mac?
      assert_equal "Homebrew\n", shell_output(bin/"gmake")
      assert_equal "Homebrew\n", shell_output(libexec/"gnubin/make")
    else
      assert_equal "Homebrew\n", shell_output(bin/"make")
    end
  end
end
