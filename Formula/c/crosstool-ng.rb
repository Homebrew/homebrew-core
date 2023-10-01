class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "https://crosstool-ng.github.io/"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.26.0.tar.xz"
  sha256 "e8ce69c5c8ca8d904e6923ccf86c53576761b9cf219e2e69235b139c8e1b74fc"
  license "GPL-2.0-only"
  head "https://github.com/crosstool-ng/crosstool-ng.git", branch: "master"

  livecheck do
    url "https://crosstool-ng.github.io/download/"
    regex(/href=.*?crosstool-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4e89106ff9e0491a77f299440dddd366c4fe42c6d41a3e16dfc1267c3e012e5a"
    sha256 cellar: :any,                 arm64_ventura:  "63e6ff7e32be6449940671eca17016ea8c9d80c6f7252e209989536542beef08"
    sha256 cellar: :any,                 arm64_monterey: "71031d1dd05a389a19f549f1354635da8b0ec6462ca5a808a35b2f3165747331"
    sha256 cellar: :any,                 arm64_big_sur:  "9643425a8450bda42ab2bab1bef5d22ace5c0525d206010425fe9f4cb3abcb07"
    sha256 cellar: :any,                 sonoma:         "da7a4892ff1e6000d74c8fea569ed91483e964ab164e0c8188b070a6b83fa988"
    sha256 cellar: :any,                 ventura:        "116d161e3ba7a6150773572ae640004208744a0ecfab39f72f61debcb55c3212"
    sha256 cellar: :any,                 monterey:       "579bd3956156eba1aebe0e683693b4bb1feec1c4a6def514385403212c0f7b0e"
    sha256 cellar: :any,                 big_sur:        "9a5104ab1aeb98fe2c5052f5f1e48ff47430c2736b0ecdf71893b09ad94bedcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "634af595334c49bd6ff26f9cb0d77b99fac85f65b5b5b1663deafc5b6c6da0ac"
  end

  depends_on "help2man" => :build
  depends_on "autoconf"
  depends_on "automake"
  depends_on "binutils"
  depends_on "bison"
  depends_on "flex"
  depends_on "gettext"
  depends_on "libtool"
  depends_on "lzip"
  depends_on "m4"
  depends_on "ncurses"
  depends_on "python@3.11"
  depends_on "xz"

  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "unzip" => :build

  on_macos do
    depends_on "bash"
    depends_on "coreutils"
    depends_on "gawk"
    depends_on "gnu-sed"
    depends_on "grep"
    depends_on "make"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./bootstrap" if build.head?

    ENV["BISON"] = Formula["bison"].opt_bin/"bison"
    ENV["M4"] = Formula["m4"].opt_bin/"m4"
    ENV["PYTHON"] = Formula["python@3.11"].opt_bin/"python3.11"

    if OS.mac?
      ENV["MAKE"] = Formula["make"].opt_bin/"gmake"
      ENV.append "LDFLAGS", "-lintl"
    else
      ENV.append "CFLAGS", "-I#{Formula["ncurses"].include}/ncursesw"
    end

    system "./configure", "--prefix=#{prefix}"

    # Must be done in two steps
    system "make"
    system "make", "install"

    inreplace [bin/"ct-ng", pkgshare/"paths.sh"], Superenv.shims_path/"gmake", "gmake" unless OS.mac?
  end

  test do
    assert_match "This is crosstool-NG", shell_output("make -rf #{bin}/ct-ng version")
  end
end
