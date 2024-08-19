class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/cd/74/ad3d526f3bf7b6d3f408b73fde271ec69dfac8b81341a318ce825f2b3812/pillow-10.4.0.tar.gz"
  sha256 "166c1cd4d24309b30d61f79f4a9114b7b2313d7450912277855ff5dfd7cd4a06"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "ccb180b86306c317c1bb86d0851af16db3cd9201ec73075a3f41de4ff45bf671"
    sha256 cellar: :any, arm64_ventura:  "2c597522196c225fe2894826aeb6383dfc2238aed96434b9070c214f5957e97c"
    sha256 cellar: :any, arm64_monterey: "ebe4315cc2b641f01e16b0935903ff67b468a6f9bef8d6e765a312f34429fc47"
    sha256 cellar: :any, sonoma:         "144bb6d5a53ee094cd62bd3afb170e56a504b11f7473a09d66e8a3cb4a645bd8"
    sha256 cellar: :any, ventura:        "b7a6bd36c51f17bdfa08b70e28043c17d03ce684c4b8386ff239c8a2d9d36051"
    sha256 cellar: :any, monterey:       "e33f426090c7351563c784b9f7553e57d91648ae296d7240a0ae38592ee97f0d"
    sha256               x86_64_linux:   "87f4aaed2277535ec83f77355fa3c3351c1b56ed688bd4225a87b2b54b1ef038"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libimagequant"
  depends_on "libraqm"
  depends_on "libtiff"
  depends_on "libxcb"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "tcl-tk"
  depends_on "webp"

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    ENV["MAX_CONCURRENCY"] = ENV.make_jobs.to_s
    deps.each do |dep|
      next if dep.build? || dep.test?

      ENV.prepend "CPPFLAGS", "-I#{dep.to_formula.opt_include}"
      ENV.prepend "LDFLAGS", "-L#{dep.to_formula.opt_lib}"
    end

    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(build_isolation: true),
                     "-C", "debug=true", # Useful in case of build failures.
                     "-C", "tiff=enable",
                     "-C", "freetype=enable",
                     "-C", "lcms=enable",
                     "-C", "webp=enable",
                     "-C", "xcb=enable",
                     "."
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      from PIL import Image
      im = Image.open("#{test_fixtures("test.jpg")}")
      print(im.format, im.size, im.mode)
    EOS

    pythons.each do |python|
      assert_equal "JPEG (1, 1) RGB", shell_output("#{python} test.py").chomp
    end
  end
end
