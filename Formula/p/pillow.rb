class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/cd/74/ad3d526f3bf7b6d3f408b73fde271ec69dfac8b81341a318ce825f2b3812/pillow-10.4.0.tar.gz"
  sha256 "166c1cd4d24309b30d61f79f4a9114b7b2313d7450912277855ff5dfd7cd4a06"
  license "HPND"
  revision 1
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "0117a48ed458639fbeb31a7972bafd3c0a9b06104011ccd4a7b0f5812b08b626"
    sha256 cellar: :any, arm64_sonoma:  "ff97f4d05a95efb8b0fee5ecd488d3ec4d1a08a42fb83419cb4c187bb8ac36e4"
    sha256 cellar: :any, arm64_ventura: "9c499f2ee136fdd5ebfb9a5882ec68c4a6e6eaf36a23f65cbd7f155b77cabf4c"
    sha256 cellar: :any, sonoma:        "6187bc4583f25d0217dcfb6f9f6fc79d934d8cb1a3fe3e40205b4e902abeac6b"
    sha256 cellar: :any, ventura:       "c7bca225a92ee3b57d2816f1323fd3d080294c8fe20c9ae6cb63fbb42dd32ac2"
    sha256               x86_64_linux:  "72460570398320cf0bf3b17fd673258121bd61b60baf8b49d75dfdde99ee4269"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
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
