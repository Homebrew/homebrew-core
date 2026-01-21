class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.github.io/"
  url "https://files.pythonhosted.org/packages/d0/02/d52c733a2452ef1ffcc123b68e6606d07276b0e358db70eabad7e40042b7/pillow-12.1.0.tar.gz"
  sha256 "5c5ae0a06e9ea030ab786b0251b32c7e4ce10e58d983c0d5c56029455180b5b9"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f1cc35bb04a8d357cc3a374fdae3c5907b81aeb08b766c89551ccb41cac655e3"
    sha256 cellar: :any, arm64_sequoia: "8f663e601bed2880fb64c36c04832baabd41010e593b098312f0ec65d119cedf"
    sha256 cellar: :any, arm64_sonoma:  "30184a3281f66c5d7523a9632d64968677e2a2c650eac588b3552fc1deeba3df"
    sha256 cellar: :any, sonoma:        "bdae0ae4039f16e305c73799d20b739fddabe5cb33ec5c6a4c01b7bad4dba8c4"
    sha256               arm64_linux:   "8e49d14f11815297cc6cee9a2ad896741592054089f46732a7c5808a22db0a49"
    sha256               x86_64_linux:  "00056eb146e22b5ea8f4599591049bd7282421e0f7d9881a407cdfca3efe1c7f"
  end

  depends_on "pkgconf" => :build
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
