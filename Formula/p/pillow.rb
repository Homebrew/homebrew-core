class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.github.io/"
  url "https://files.pythonhosted.org/packages/f3/0d/d0d6dea55cd152ce3d6767bb38a8fc10e33796ba4ba210cbab9354b6d238/pillow-11.3.0.tar.gz"
  sha256 "3828ee7586cd0b2091b6209e5ad53e20d0649bbe87164a459d0676e035e8f523"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "7f3bb7bf3cf39d7ea983767045c4d51a23490759e6e887b6ac1c78aeccbe9b85"
    sha256 cellar: :any, arm64_sequoia: "138890e7acddd45d3b85aa806f0d49bf1e0426a3f5c3d62abf9b0bdc6ffd3ec9"
    sha256 cellar: :any, arm64_sonoma:  "072ca716449f92fc41973226a562e07b3b68edc481ed2399dc1b41ddd6dfebe1"
    sha256 cellar: :any, arm64_ventura: "5d131476706a4d24992d79d642f065b1f902b1769b550b13115ce0d77e27ee5b"
    sha256 cellar: :any, sonoma:        "329eae672cd5995f645feb40b9faca5d8cfe5664b2e70f31fd8e15101f466fd5"
    sha256 cellar: :any, ventura:       "21928803827d549ce8e98675afa2d3324157db755babc8465133cc693163e1cb"
    sha256               arm64_linux:   "4d2fc2cf7945642b674594b50e7dff4670d85955827c3d58f1dc451e5469fd8f"
    sha256               x86_64_linux:  "3cfc3636c299c00e610c63d90c8aa3758b1332d1e7cb4fba81fb0897da3f34a1"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
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
