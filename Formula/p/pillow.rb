class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.github.io/"
  url "https://files.pythonhosted.org/packages/5a/b0/cace85a1b0c9775a9f8f5d5423c8261c858760e2466c79b2dd184638b056/pillow-12.0.0.tar.gz"
  sha256 "87d4f8125c9988bfbed67af47dd7a953e2fc7b0cc1e7800ec6d2080d490bb353"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ff2bbd99dda7ce7abb304d4928959c1724f6ddf193194021b1c3074966eeb4b3"
    sha256 cellar: :any, arm64_sequoia: "1833bd4053addaf27fc722cd8a492436a59e3cf02a219a94bf84f49c63537d2e"
    sha256 cellar: :any, arm64_sonoma:  "fcb4113eb505824c5c113b6aef44af0dea7b9bf7c877f07483d5ebed1265948a"
    sha256 cellar: :any, sonoma:        "e54ba44aa57a4ca0654b4dd48e65205b1d410f232658280ca24af471bacc6bae"
    sha256               arm64_linux:   "b106456d1752531caca067c9a2759f5eb27da100fb40adf30b6326056e7edc8d"
    sha256               x86_64_linux:  "46340278cadab63940fbcf66191001ac0ab1e89522c9cd9801cf484939e963c3"
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
