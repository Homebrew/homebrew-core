class Expect < Formula
  desc "Program that can automate interactive applications"
  homepage "https://core.tcl-lang.org/expect/index"
  url "https://downloads.sourceforge.net/project/expect/Expect/5.45.4/expect5.45.4.tar.gz"
  sha256 "49a7da83b0bdd9f46d04a04deec19c7767bb9a323e40c4781f89caf760b92c34"
  license :public_domain
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/expect-?v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "02453adc4b8102ccdea2eddf5bb2a282ad6a62ad373121bf6ee6d9273e3d6d4c"
    sha256 arm64_sequoia: "bc49887735929062d3e347a111a7b53a0de95813652d626f00d9b5663ecb0c1d"
    sha256 arm64_sonoma:  "67bbdee9a025af2b9a8be9a9f6a1692078f5ce4d2b6528b2bad75ff41154dee9"
    sha256 arm64_ventura: "095903e79761e107ffdca6ebf7833be3d83437977a1e7fd5e962f7d4a46014ba"
    sha256 sonoma:        "8e07086c078379a4c6cdbde7b14b70376228b8a15798fc32059c9336287ce18b"
    sha256 ventura:       "3e841e410fdcbb63b135eda50a712df978fa54e6288347718a63fcc77d5cb8e7"
    sha256 arm64_linux:   "d58c5bfe8071a22c8d2a868ea97b122feca090b9641d58f5f80dd4f7de7385ba"
    sha256 x86_64_linux:  "500bbf556dea3b9536753959c9a2a7c6c8b8d79ac929ce3008529812b62f6209"
  end

  # Autotools are introduced here to regenerate configure script. Remove
  # if the patch has been applied in newer releases.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "tcl-tk@8"

  conflicts_with "ircd-hybrid", because: "both install an `mkpasswd` binary"
  conflicts_with "bash-snippets", because: "both install `weather` binaries"

  # Patch for configure scripts and various headers:
  # https://core.tcl-lang.org/expect/tktview/0d5b33c00e5b4bbedb835498b0360d7115e832a0
  # Appears to fix a segfault on ARM Ventura:
  # https://github.com/Homebrew/homebrew-core/pull/123513
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/expect/headers.diff"
    sha256 "7a4d5c958b3e51a08368cae850607066baf9c049026bec11548e8c04cec363ef"
  end

  # Fix a segfault in exp_getptymaster()
  # Commit taken from Iain Sandoe's branch at https://github.com/iains/darwin-expect
  patch do
    url "https://github.com/iains/darwin-expect/commit/2a98bd855e9bf2732ba6ddbd490b748d5668eeb0.patch?full_index=1"
    sha256 "deb83cfa2475b532c4e63b0d67e640a4deac473300dd986daf650eba63c4b4c0"
  end

  def install
    tcltk = Formula["tcl-tk@8"]
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
    bin.env_script_all_files libexec/"bin",
                             PATH:       "#{tcltk.opt_bin}:$PATH",
                             TCLLIBPATH: lib.to_s
    # "expect" is already linked to "tcl-tk", no shim required
    bin.install libexec/"bin/expect"
  end

  test do
    assert_match "works", shell_output("echo works | #{bin}/timed-read 1")
    assert_empty shell_output("{ sleep 3; echo fails; } | #{bin}/timed-read 1 2>&1")
    assert_match "Done", pipe_output(bin/"expect", "exec true; puts Done")
  end
end
