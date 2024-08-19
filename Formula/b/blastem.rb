class Blastem < Formula
  desc "Fast and accurate Genesis emulator"
  homepage "https://www.retrodev.com/blastem/"
  url "https://www.retrodev.com/repos/blastem/archive/v0.6.2.tar.gz"
  sha256 "d460632eff7e2753a0048f6bd18e97b9d7c415580c358365ff35ac64af30a452"
  license "GPL-3.0-or-later"
  revision 2
  head "https://www.retrodev.com/repos/blastem", using: :hg

  livecheck do
    url "https://www.retrodev.com/repos/blastem/json-tags"
    regex(/["']tag["']:\s*?["']v?(\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 sonoma:       "ecd7349a29964734c3639455aa169fb122b6610e1ad4e156b5b7a8da440565ea"
    sha256 cellar: :any,                 ventura:      "e596f3a0411f92741ccfcd5e9f5112e48d586c6c7445c477e0954ef62d91a711"
    sha256 cellar: :any,                 monterey:     "a05456feadfedff7fc89b7e018b801121e92d27cf280dce0bb5edcbb18fcb488"
    sha256 cellar: :any,                 big_sur:      "5a1d5caf1b0fc3f0f7887432c80c6cb49f1b3dc336a9873558d5f6b7c94ae099"
    sha256 cellar: :any,                 catalina:     "684ac27d7251db585b84112c9721fbafab44e24bb4dbee60a161f1b772ccb82d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "34eecdcd05c078faa3ca11075058a9fc3c5f4c80f69de0bdc927779fe623a9c9"
  end

  depends_on "imagemagick" => :build
  depends_on "pillow" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on arch: :x86_64
  depends_on "glew"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
  end

  resource "vasm" do
    url "http://phoenix.owl.de/tags/vasm1_8i.tar.gz"
    sha256 "9ae0b37bca11cae5cf00e4d47e7225737bdaec4028e4db2a501b4eca7df8639d"
  end

  # Convert Python 2 script to Python 3. Remove with next release.
  patch do
    url "https://www.retrodev.com/repos/blastem/raw-rev/dbbf0100f249"
    sha256 "e332764bfa08e08e0f9cbbebefe73b88adb99a1e96a77a16a0aeeae827ac72ff"
  end

  # Fix build with -fno-common which is default in GCC 10+. Remove with next release.
  patch do
    on_linux do
      url "https://www.retrodev.com/repos/blastem/raw-rev/e45a317802bd"
      sha256 "8f869909df6eb66375eea09dde806422aa007aee073d557b774666f51c2e40dd"
    end
  end

  def install
    resource("vasm").stage do
      system "make", "CPU=m68k", "SYNTAX=mot"
      (buildpath/"tool").install "vasmm68k_mot"
    end
    ENV.prepend_path "PATH", buildpath/"tool"

    # Use imagemagick to convert XCF files instead of xcftools, which is unmaintained and broken.
    # Fix was sent to upstream developer.
    inreplace "Makefile", "xcf2png $< > $@", "convert $< $@"

    system "make", "all", "menu.bin", "HOST_ZLIB=1"
    libexec.install %w[blastem default.cfg menu.bin rom.db shaders]
    bin.write_exec_script libexec/"blastem"
  end

  test do
    assert_equal "blastem #{version}", shell_output("#{bin}/blastem -b 1 -v").chomp
  end
end
