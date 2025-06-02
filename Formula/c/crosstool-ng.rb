class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "https://crosstool-ng.github.io/"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.27.0.tar.xz"
  sha256 "0506ab98fa0ad6d263a555feeb2c7fff9bc24a434635d4b0cdff9137fe5b4477"
  license "GPL-2.0-only"
  head "https://github.com/crosstool-ng/crosstool-ng.git", branch: "master"

  livecheck do
    url "https://crosstool-ng.github.io/download/"
    regex(/href=.*?crosstool-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "86c8e7e727cd75f79bb97d01765d510b48085412d7327b5d06f0f633021d26d9"
    sha256 cellar: :any,                 arm64_sonoma:  "5e90dd18b0af819e9d7816b6ac239dd9b7636fc4976401468570b85f4a59ac21"
    sha256 cellar: :any,                 arm64_ventura: "6ce8cb522f4b57f144017581913ebd9b9f401ebb80efb9b3efc0907299606272"
    sha256 cellar: :any,                 sonoma:        "17ac89a41e37fa2f8e04122b22b49209a21d19dbccf9ad492dce6139ad64355d"
    sha256 cellar: :any,                 ventura:       "339070b60acf2dfd7684df759c21f8c354baa6f1aa7a4b5a249c843d7724d55e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "195c38b9f2a0a0ea25670a34a99756be7fc60e7735abe6197818c79d195bb063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44af39329adc4bf0bed2b213d5a9f7c6ae51b517ffb6a63814ce60be6e042b21"
  end

  depends_on "help2man" => :build
  depends_on "autoconf"
  depends_on "automake"
  depends_on "binutils"
  depends_on "bison"
  depends_on "flex"
  depends_on "libtool"
  depends_on "lzip"
  depends_on "m4"
  depends_on "ncurses"
  depends_on "python@3.13"
  depends_on "xz"

  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "unzip" => :build

  on_macos do
    depends_on "bash"
    depends_on "coreutils"
    depends_on "gawk"
    depends_on "gettext"
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
    ENV["PYTHON"] = Formula["python@3.13"].opt_bin/"python3.13"

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
