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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "c3beaab909d4b0890ce0b6264c18981a6afbe7ee2487f49d01ae5b51c12ff6c6"
    sha256 cellar: :any,                 arm64_ventura:  "d177d9aa721b098257b31e09b64d8e9ff9eea1f49ea75e20333c304778100f2a"
    sha256 cellar: :any,                 arm64_monterey: "a0899205ebaa1b23ba3808277821a75fe418dd0929a1a35bc736f0ed32ff20df"
    sha256 cellar: :any,                 sonoma:         "1c5e8c757523288697612a1474709ab06b89dbfbced6b26ff2384858dbceb1a3"
    sha256 cellar: :any,                 ventura:        "8107a048de577c810cc5404b6949decc44b6f50ee812576facbfa884607f99de"
    sha256 cellar: :any,                 monterey:       "fc5ae025b96ac3410b52e92475db88bbc06f81252cd5d096177efd6d1a681f55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a309a9662fc4b2f991e21fde07dd0e4b552829d36add35543991cf77ea7d6b3d"
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
  depends_on "python@3.12"
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
    ENV["PYTHON"] = Formula["python@3.12"].opt_bin/"python3.12"

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
