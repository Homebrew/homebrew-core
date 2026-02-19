class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.github.io/"
  url "https://files.pythonhosted.org/packages/1f/42/5c74462b4fd957fcd7b13b04fb3205ff8349236ea74c7c375766d6c82288/pillow-12.1.1.tar.gz"
  sha256 "9ad8fa5937ab05218e2b6a4cff30295ad35afd2f83ac592e68c0d871bb0fdbc4"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "608dc8063cbbea272a1d80555038705ba9faf8a732ae510ebd15e84dd426271a"
    sha256 cellar: :any, arm64_sequoia: "0ac999cbd9b63f14112d86e6e0d987d3ad0b33a5fa992bc6a676b27ed9c20772"
    sha256 cellar: :any, arm64_sonoma:  "5380e49362ae6f6ab0f40699bff8996e503e19f6c6743d3049138e99d1b3966e"
    sha256 cellar: :any, sonoma:        "b6e52594c64c36b21ad89fca370b5820adec04233ef7cc083f7c35f38e86052a"
    sha256               arm64_linux:   "befb876d3acb63de7c9365043b85f589cdaaf79750dcbd402befbcc772147842"
    sha256               x86_64_linux:  "b5ae4fb7868bc8cf959a5fd340f76014276e9cf40aa1421dfa92d242d305819c"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libavif"
  depends_on "libimagequant"
  depends_on "libraqm"
  depends_on "libtiff"
  depends_on "libxcb"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
                     "-C", "avif=enable",
                     "."
    end
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from PIL import Image
      im = Image.open("#{test_fixtures("test.jpg")}")
      print(im.format, im.size, im.mode)
    PYTHON

    pythons.each do |python|
      assert_equal "JPEG (1, 1) RGB", shell_output("#{python} test.py").chomp
    end

    # Test webp support
    resource "test-webp" do
      url "https://raw.githubusercontent.com/python-pillow/Pillow/refs/heads/main/Tests/images/flower.webp"
      sha256 "af5bf1a0e420467c09d221fbfbb739646956c17f2b67f8280eacfacf87059a37"
    end

    testpath.install resource("test-webp")
    test_webp = testpath/"flower.webp"
    (testpath/"test_webp.py").write <<~PYTHON
      from PIL import Image
      im = Image.open("#{test_webp}")
      print(im.format, im.size, im.mode)
    PYTHON

    pythons.each do |python|
      assert_equal "WEBP (480, 360) RGB", shell_output("#{python} test_webp.py").chomp
    end

    # Test avif support
    resource "test-avif" do
      url "https://raw.githubusercontent.com/python-pillow/Pillow/refs/heads/main/Tests/images/avif/exif.avif"
      sha256 "438dc63eb5aa722f4b23a93ac48cd0c19b7a575865c89e666c86b7ac363cff04"
    end

    testpath.install resource("test-avif")
    test_avif = testpath/"exif.avif"
    (testpath/"test_avif.py").write <<~PYTHON
      from PIL import Image
      im = Image.open("#{test_avif}")
      print(im.format, im.size, im.mode)
    PYTHON

    pythons.each do |python|
      assert_equal "AVIF (512, 512) RGB", shell_output("#{python} test_avif.py").chomp
    end
  end
end
