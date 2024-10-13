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
    rebuild 2
    sha256 arm64_sequoia:  "1155721ca9166f849b6ecc739a43ecfe6f20c056ff050f39e520f87f11ac8475"
    sha256 arm64_sonoma:   "25b5d92689067d186416b78ffa0524d5a02a3e1c7068db8998dffaed2dd02e0c"
    sha256 arm64_ventura:  "848515e0ab82921d9292b7a616d33dc02e9dfcaab91793ec4d5ef241c3e08f29"
    sha256 arm64_monterey: "753d526bf20551dde2c60c1580989292e8c8f5f436da14b6901ec92a8bc30f6a"
    sha256 arm64_big_sur:  "664f8a8ff901cacbe76465d4f13dc0ca775ccb0b48b34fa0aeb02b1e2e4dfe82"
    sha256 sonoma:         "60f75545be4c3bc3f91dc895770d20654ee7112da5e92950ab49b3ef6e577538"
    sha256 ventura:        "25d93f37370c458e865d809dd3489c1843acdc21dd74cabf2413e49f15d7994b"
    sha256 monterey:       "37b95bd265607a74986db6259597e98963a0ff2d845533918105e9396b8f8d24"
    sha256 big_sur:        "8462f3377db850b33a44bea729acd7b8c516aca8ed24d70b155c6b965f6997b1"
    sha256 x86_64_linux:   "1386f4bebace25fb0635d385ada1481d5a176a80cf880bbcbf3612aacfccd570"
  end

  # Autotools are introduced here to regenerate configure script. Remove
  # if the patch has been applied in newer releases.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "tcl-tk"

  conflicts_with "ircd-hybrid", because: "both install an `mkpasswd` binary"
  conflicts_with "bash-snippets", because: "both install `weather` binaries"

  # Patch for configure scripts and various headers:
  # https://core.tcl-lang.org/expect/tktview/0d5b33c00e5b4bbedb835498b0360d7115e832a0
  # Appears to fix a segfault on ARM Ventura:
  # https://github.com/Homebrew/homebrew-core/pull/123513
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/49c39ceebb547fc1965ae2c8d423fd8c082b52a7/expect/headers.diff"
    sha256 "7a4d5c958b3e51a08368cae850607066baf9c049026bec11548e8c04cec363ef"
  end

  # Fix a segfault in exp_getptymaster()
  # Commit taken from Iain Sandoe's branch at https://github.com/iains/darwin-expect
  patch do
    url "https://github.com/iains/darwin-expect/commit/2a98bd855e9bf2732ba6ddbd490b748d5668eeb0.patch?full_index=1"
    sha256 "deb83cfa2475b532c4e63b0d67e640a4deac473300dd986daf650eba63c4b4c0"
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
    assert_match "Done", pipe_output(bin/"expect", "exec true; puts Done")
  end
end
