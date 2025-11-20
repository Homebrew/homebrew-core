class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "https://crosstool-ng.github.io/"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.28.0.tar.xz"
  sha256 "5750e29a2bda5cd8d67900592576b1670a1987a4dcd5e4f6beae09138a1f5699"
  license "GPL-2.0-only"
  head "https://github.com/crosstool-ng/crosstool-ng.git", branch: "master"

  livecheck do
    url "https://crosstool-ng.github.io/download/"
    regex(/href=.*?crosstool-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a8ff126a8c7e5be835e5b9ca34fde60183b12e038a84d6778ceb349d198b3a47"
    sha256 cellar: :any,                 arm64_sequoia: "19ca62b038fe2d81cca3c0a7e21c3ab649a8d16c948eb779f888138cfc46abaf"
    sha256 cellar: :any,                 arm64_sonoma:  "360739dd3cd49d742e279f6d2ad2a99db93e3980f3e10b6f150451fe58409276"
    sha256 cellar: :any,                 sonoma:        "9416e83f34a15f21252eb6d4e91850d62477a5ecad86778ae92322153fed5312"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4e308a1106873d2467839381200620a02112b77840187989ad730f19b5dc6bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cf9a85553d3767dc3f0b1d9c34958e284b5e6c948d46b63d5c81b1c216d422e"
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
  depends_on "python@3.14"
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
    ENV["PYTHON"] = Formula["python@3.14"].opt_bin/"python3.14"

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
