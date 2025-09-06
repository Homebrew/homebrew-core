class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "3a76ed8c8481e5499c8fedbba3b6af4f33f73bbbfc4e6154ea50fe48ae7054a9"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "e916b8467a227287c206c34a792a829864578ba2c98c69206e07ca78c6bb05ca"
    sha256 cellar: :any,                 arm64_sonoma:  "f1ace5b789f7744191de53a328cd7927b446e7c1df4a0829faa66abcb46e6c72"
    sha256 cellar: :any,                 arm64_ventura: "50450c237463b39c7bd5a4e128882b1f64ad20d7e96f1681a8c0f3cc44eee082"
    sha256 cellar: :any,                 sonoma:        "ce1a8e0d975c410c41b5a640e43963d7ee3cc40831bc1fa2deb9f6178f8457c2"
    sha256 cellar: :any,                 ventura:       "8f35bf9cd5ddf6ae48700da2485759bedbe60cf24d8c5ac57b2569609ff11e2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5476fe8a3f601975b8382daddd4db0cc107ae7c332d2db1155c87b46b9521602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b40f19c65b043198073b51666bd582f44a150e3712d0c3287ab35f375372e17a"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "protozero" => :build
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"
  depends_on "lz4"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
  # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
  # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
  def remove_brew_expat
    env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
    ENV.remove env_vars, /(^|:)#{Regexp.escape(Formula["expat"].opt_prefix)}[^:]*/
    ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
  end

  def install
    remove_brew_expat if OS.mac? && MacOS.version < :sequoia

    protozero = Formula["protozero"].opt_include
    args = %W[
      -DPROTOZERO_INCLUDE_DIR=#{protozero}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"input.opl").write <<~OPL
      n100 v1 x1.01 y1.01
      n101 v1 x1.04 y1.01
      n102 v1 x1.04 y1.04
      n103 v1 x1.01 y1.04
      w200 v1 Tnatural=coastline Nn100,n101,n102,n103,n100
    OPL
    system bin/"osmcoastline", "-v", "-o", "output.db", "input.opl"
  end
end
