class Blastem < Formula
  desc "Fast and accurate Genesis emulator"
  homepage "https://www.retrodev.com/blastem/"
  url "https://www.retrodev.com/repos/blastem/archive/v0.6.2.tar.gz"
  sha256 "d460632eff7e2753a0048f6bd18e97b9d7c415580c358365ff35ac64af30a452"
  license "GPL-3.0-or-later"
  revision 1
  head "https://www.retrodev.com/repos/blastem", using: :hg

  livecheck do
    url "https://www.retrodev.com/repos/blastem/json-tags"
    regex(/["']tag["']:\s*?["']v?(\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "6f3f83fd9bc9b5a259eb21ea43bdc37e4d4a8665c809b8f34d456f681d3c1d17"
    sha256 cellar: :any,                 big_sur:      "003bbd7d1f5f9d81fb471d1fff692951c9400a8bf2f1511f0d83c9bea9cb8e63"
    sha256 cellar: :any,                 catalina:     "7b9652bffa8c28d6f23e1ad88534b5f2bbd49a916566650c3090366a556f11b2"
    sha256 cellar: :any,                 mojave:       "9972096dbef1b35d3d98894c77575a4fce7c674660498e0877b95fe22383f1eb"
    sha256 cellar: :any,                 high_sierra:  "74e39ac321fe48f06927b3ac455a382f14342c007b06b083860175edca1e0062"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e55cd02a092ef31e3d13db74b551bdab7909fc5bdec0953a608407542976bf92"
  end

  depends_on "freetype" => :build
  depends_on "gettext" => :build
  depends_on "imagemagick" => :build
  depends_on "jpeg" => :build
  depends_on "libpng" => :build
  depends_on "openjpeg" => :build
  depends_on "pillow" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on arch: :x86_64
  depends_on "glew"
  depends_on "sdl2"

  uses_from_macos "libffi"

  resource "vasm" do
    url "http://phoenix.owl.de/tags/vasm1_8i.tar.gz"
    sha256 "9ae0b37bca11cae5cf00e4d47e7225737bdaec4028e4db2a501b4eca7df8639d"
  end

  # Convert Python 2 script to Python 3. Remove with next release.
  patch do
    url "https://www.retrodev.com/repos/blastem/raw-rev/dbbf0100f249"
    sha256 "e332764bfa08e08e0f9cbbebefe73b88adb99a1e96a77a16a0aeeae827ac72ff"
  end

  def install
    if MacOS.sdk_path_if_needed
      ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/ffi" # libffi
    end

    resource("vasm").stage do
      system "make", "CPU=m68k", "SYNTAX=mot"
      (buildpath/"tool").install "vasmm68k_mot"
    end

    # Use imagemagick to convert XCF files instead of xcftools, which is unmaintained and broken.
    # Fix was sent to upstream developer.
    inreplace "Makefile", "xcf2png \$< > \$@", "convert $< $@"

    ENV.prepend_path "PATH", buildpath/"tool"

    system "make", "menu.bin"
    system "make"
    libexec.install %w[blastem default.cfg menu.bin rom.db shaders]
    bin.write_exec_script libexec/"blastem"
  end

  test do
    assert_equal "blastem #{version}", shell_output("#{bin}/blastem -b 1 -v").chomp
  end
end
