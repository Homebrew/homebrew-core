class Oscats < Formula
  desc "Computerized adaptive testing system"
  homepage "https://code.google.com/archive/p/oscats/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/oscats/oscats-0.6.tar.gz"
  sha256 "2f7c88cdab6a2106085f7a3e5b1073c74f7d633728c76bd73efba5dc5657a604"
  license "GPL-3.0-or-later"
  revision 7

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "35dc1e697fe94c6ceab3be777ef3aa53ec83df8451739125105a4fa5e24e5fd7"
    sha256 cellar: :any,                 arm64_sequoia:  "14bdf254ea5eb224c087cc3bdc7ba53b46d52b77e2c440f738871e747ad7e33a"
    sha256 cellar: :any,                 arm64_sonoma:   "ee65d5fb7e853cf11866ad5d82e42443a2c899089538f7563a3d63268af2855e"
    sha256 cellar: :any,                 arm64_ventura:  "dae032204b3f3d0d874482bec11e6ba4cc34cdf088929e5e432e75960800ddd2"
    sha256 cellar: :any,                 arm64_monterey: "f348f164c17601c6fe88cbf6c0e403615f6466c286fdc6b7b5a809e0c4af0347"
    sha256 cellar: :any,                 sonoma:         "13bd95cd190928092251cd826497867f03f36d6a3f4f1deee6e00577c2bb4c23"
    sha256 cellar: :any,                 ventura:        "cafcdb6c91e58beebb50ab5fdf28a7f9246df0256be3285a49f70e6b79f6323c"
    sha256 cellar: :any,                 monterey:       "d86233a0472773367baa7cded028f338d8ee4121b742bfa8a0aa9fd275ac95fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5455564ddd14e3caddfc1af6a1f7440daf719e7446c51a0f3beefab3088ce053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cea14d82ea0d9f7fea63cbd5364ccd2a85d0d8b8e02a498904b3f1bec140712c"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "gsl"

  on_macos do
    depends_on "gettext"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  # Fix issue with conflicting definitions of select on Linux.
  # Patch submitted to discussion group:
  # https://groups.google.com/g/oscats/c/WZ7gRjkxmIk.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/oscats/linux.patch"
    sha256 "95fcfa861ed75a9292a6dfbb246a62be3ad3bd9c63db43c3d283ba68069313af"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
    pkgshare.install "examples"
    # Fix shim references in examples Makefile.
    if OS.mac?
      inreplace pkgshare/"examples/Makefile",
        Superenv.shims_path/"pkg-config",
        Formula["pkgconf"].opt_bin/"pkg-config"
    else
      inreplace pkgshare/"examples/Makefile", Superenv.shims_path/"ld", "ld"
    end
  end

  test do
    pkgconf_flags = shell_output("pkgconf --cflags --libs oscats glib-2.0").chomp.split
    system ENV.cc, "-Wno-incompatible-pointer-types", pkgshare/"examples/ex01.c", *pkgconf_flags, "-o", "ex01"
    assert_match "Done", shell_output("#{testpath}/ex01")
  end
end
