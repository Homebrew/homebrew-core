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
    sha256 arm64_ventura:  "41694fc786b834187a385fdff5719a44c8c2c61000907cf7e682eb67f6339d3b"
    sha256 arm64_monterey: "9d52fecd2233cf0b3c895c63f8ab03912fd74075244221196e9882334e743f08"
    sha256 arm64_big_sur:  "70d13137d6fc17c78f565f07c5bf9a23404fc8e658f9cf2015a8ecd3d69d4dc6"
    sha256 ventura:        "98df9a7371c178be65065294d2567deba4af4c057ff3ab09ff5474581b91985a"
    sha256 monterey:       "db086c31928306bb3e9735bdef4a06b1bdcce0e4d60bb78968e40d3e31064858"
    sha256 big_sur:        "c45b66b3d9c4a6c2b0fa68d9daec2b48bed4df6ab564ff652ce0cf41040419c3"
    sha256 catalina:       "b4899f933cfe9caea23ffa18529be2d2e2d66d828de427f9a2b3f7e1795bd10e"
    sha256 x86_64_linux:   "f5fa2ccf3978e434b52d22920f3e5a27d2f922e1838e5eede42ed6332d5d7031"
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
