class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/refs/tags/mame0261.tar.gz"
  version "0.261"
  sha256 "51d5ce1563897709ceb7a924c31a70cc5ff2bec466aab8d0cc9ff3cc72b38899"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  # MAME tags (and filenames) are formatted like `mame0226`, so livecheck will
  # report the version like `0226`. We work around this by matching the link
  # text for the release title, since it contains the properly formatted version
  # (e.g., 0.226).
  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0cf26736700f8c92942c73f18ba452b68566c3bd1813775ea21eaf0b17cdb1b9"
    sha256 cellar: :any,                 arm64_ventura:  "da91a3462dccdad9ce7c998dd88c0054bf7e24e25ed6006815dd2a1536e36836"
    sha256 cellar: :any,                 arm64_monterey: "392c334add55120c1d958f1a1c2d37993e1a19a8d1d8b3a2810048110dbaa13d"
    sha256 cellar: :any,                 sonoma:         "e211e8b48165cfa84b65152a9245263e9dc7aa3a7df3cb6269fa07b4b3fa6482"
    sha256 cellar: :any,                 ventura:        "aa27b909bdceeff5dfc873c9f26102d49a8444a4025248b9bebd7a8e6b3017b6"
    sha256 cellar: :any,                 monterey:       "b39b24721a05dd6f0ea1732404268c551208821c70be2c59e3e2f54e8443719a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88f2d6d965e6e0d5189b8c03b78cb9018ffbbe040bdde4cfe50e8e2f31207aa2"
  end

  depends_on "asio" => :build
  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "rapidjson" => :build
  depends_on "sphinx-doc" => :build
  depends_on "flac"
  depends_on "jpeg-turbo"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "pugixml"
  depends_on "sdl2"
  depends_on "sqlite"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pulseaudio"
    depends_on "qt"
    depends_on "sdl2_ttf"
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  patch :DATA

  def install
    ENV["QT_HOME"] = Formula["qt"].opt_prefix if OS.linux?

    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # Use bundled lua instead of latest version.
    # https://github.com/mamedev/mame/issues/5349
    system "make", "PYTHON_EXECUTABLE=#{which("python3.12")}",
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_ASIO=1",
                   "USE_SYSTEM_LIB_LUA=",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_GLM=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_PORTAUDIO=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_PUGIXML=1",
                   "USE_SYSTEM_LIB_RAPIDJSON=1",
                   "USE_SYSTEM_LIB_SQLITE3=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1"
    bin.install "mame"
    cd "docs" do
      # We don't convert SVG files into PDF files, don't load the related extensions.
      inreplace "source/conf.py", "'sphinxcontrib.rsvgconverter',", ""
      system "make", "text"
      doc.install Dir["build/text/*"]
      system "make", "man"
      man1.install "build/man/MAME.1" => "mame.1"
    end
    pkgshare.install %w[artwork bgfx hash ini keymaps language plugins samples uismall.bdf]
  end

  test do
    assert shell_output("#{bin}/mame -help").start_with? "MAME v#{version}"
    system "#{bin}/mame", "-validate"
  end
end

__END__
diff --git a/scripts/src/osd/modules.lua b/scripts/src/osd/modules.lua
index f779912deb2..38a9f0ce76f 100644
--- a/scripts/src/osd/modules.lua
+++ b/scripts/src/osd/modules.lua
@@ -382,8 +382,13 @@ function qtdebuggerbuild()
 				if (MOCTST=='') then
 					MOCTST = backtick(_OPTIONS["QT_HOME"] .. "/libexec/moc --version 2>/dev/null")
 					if (MOCTST=='') then
-						print("Qt's Meta Object Compiler (moc) wasn't found!")
-						os.exit(1)
+						local qt_host_libexecs = backtick(_OPTIONS["QT_HOME"] .. "/bin/qmake -query QT_HOST_LIBEXECS")
+						MOCTST = backtick(qt_host_libexecs .. "/moc --version 2>/dev/null")
+						if (MOCTST=='') then
+							print("Qt's Meta Object Compiler (moc) wasn't found!")
+							os.exit(1)
+						end
+						MOC = qt_host_libexecs .. "/moc"
 					else
 						MOC = _OPTIONS["QT_HOME"] .. "/libexec/moc"
 					end
