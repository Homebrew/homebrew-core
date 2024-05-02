class ArmNoneEabiGdb < Formula
  desc "GNU debugger for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-14.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-14.2.tar.xz"
  sha256 "2d4dd8061d8ded12b6c63f55e45344881e8226105f4d2a9b234040efa5ce7772"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sonoma:   "5f2bce4bfb9515f2252c53cbd353df65af5b22f685dd30da34f9d85c33762b51"
    sha256 arm64_ventura:  "bd11590d85c8d7fed140e2e87d79dff67503c06e9b5691ee91eb69143b8524d0"
    sha256 arm64_monterey: "b5d702336686b39598b9dfbd632e691cba66485f767136d7f085adc142343e8b"
    sha256 sonoma:         "bc119dd0e1c4b191a1a3234a2b779c98dab1cd1e93a8d0bd54b3a046bca77344"
    sha256 ventura:        "21b5e7e040736cfce044b927fb6ba238c9c3f379bceb46055bac805e3ea3f219"
    sha256 monterey:       "f755b803b442cfb7f731f4ba0a522153a27fd9536e8a6a2f6eeb3f735dd0dc6e"
    sha256 x86_64_linux:   "bbcd5e3cdf0a3db13f8acaaeab5223c5c0c9a6f78c7b5f72beac90bab56bba83"
  end

  depends_on "arm-none-eabi-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "arm-none-eabi"
    args = %W[
      --target=#{target}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --with-lzma
      --with-python=#{Formula["python@3.12"].opt_bin}/python3.12
      --with-system-zlib
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args, *std_configure_args
      ENV.deparallelize # Error: common/version.c-stamp.tmp: No such file or directory
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    (testpath/"test.c").write "void _start(void) {}"
    system "#{Formula["arm-none-eabi-gcc"].bin}/arm-none-eabi-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/arm-none-eabi-gdb -batch -ex 'info address _start' a.out")
  end
end
