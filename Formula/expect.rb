class Expect < Formula
  desc "Program that can automate interactive applications"
  homepage "https://core.tcl-lang.org/expect/index"
  url "https://downloads.sourceforge.net/project/expect/Expect/5.45.4/expect5.45.4.tar.gz"
  sha256 "49a7da83b0bdd9f46d04a04deec19c7767bb9a323e40c4781f89caf760b92c34"
  license :public_domain
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/expect-?v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "b4365dcb8458401c304c3a3caa4f4011f9329070b35c3a676487ee19f30b1cba"
    sha256 arm64_monterey: "5ff98a9cf5b047096aab9a160a8c712d233ecf7db36beb3266558eccc192db59"
    sha256 arm64_big_sur:  "2fc1bd04e2b574486ae498ef9f4ce15ca8d984d9dc62a0edf62a04e3a4462801"
    sha256 ventura:        "6d59e098a54143167156956fa665bb0135c9928df4fee1f3cfc03371cb5c0b11"
    sha256 monterey:       "846fa2041ea776fc3bc210bd38b1021761e4093dbb8bf7370c3e94dd37d77fea"
    sha256 big_sur:        "f295e826b5797266fdceb33482e8dab427a4c2c2650a92537a440db22e74b8c1"
    sha256 x86_64_linux:   "0163251e6adfe08adac9e1a2493266eded980c8eee028ee83228599ddb3c1224"
  end

  # Autotools are introduced here to regenerate configure script. Remove
  # if the patch has been applied in newer releases.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "tcl-tk"

  conflicts_with "ircd-hybrid", because: "both install an `mkpasswd` binary"

  # Patch for configure scripts and various headers:
  # https://core.tcl-lang.org/expect/tktview/0d5b33c00e5b4bbedb835498b0360d7115e832a0
  # Appears to fix a segfault on ARM Ventura:
  # https://github.com/Homebrew/homebrew-core/pull/123513
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/49c39ceebb547fc1965ae2c8d423fd8c082b52a7/expect/headers.diff"
    sha256 "7a4d5c958b3e51a08368cae850607066baf9c049026bec11548e8c04cec363ef"
  end

  def install
    tcltk = Formula["tcl-tk"]
    args = %W[
      --prefix=#{prefix}
      --exec-prefix=#{prefix}
      --mandir=#{man}
      --enable-shared
      --enable-64bit
      --with-tcl=#{tcltk.opt_lib}
    ]

    # Workaround for ancient config files not recognising aarch64 macos.
    am = Formula["automake"]
    am_share = am.opt_share/"automake-#{am.version.major_minor}"
    %w[config.guess config.sub].each do |fn|
      cp am_share/fn, "tclconfig/#{fn}"
    end

    # Regenerate configure script. Remove after patch applied in newer
    # releases.
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *args
    system "make"
    system "make", "install"
    lib.install_symlink Dir[lib/"expect*/libexpect*"]
    if OS.mac?
      bin.env_script_all_files libexec/"bin",
                               PATH:       "#{tcltk.opt_bin}:$PATH",
                               TCLLIBPATH: lib.to_s
      # "expect" is already linked to "tcl-tk", no shim required
      bin.install libexec/"bin/expect"
    end
  end

  test do
    assert_match "works", shell_output("echo works | #{bin}/timed-read 1")
    assert_equal "", shell_output("{ sleep 3; echo fails; } | #{bin}/timed-read 1 2>&1")
    assert_match "Done", pipe_output("#{bin}/expect", "exec true; puts Done")
  end
end
