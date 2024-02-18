class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/f8/3e/32cbd0129a28686621434cbf17bb64bf1458bfb838f1f668262fefce145c/pillow-10.2.0.tar.gz"
  sha256 "e87f0b2c78157e12d7686b27d63c070fd65d994e8ddae6f328e0dcf4a0cd007e"
  license "HPND"
  revision 1
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "344b9bf598d2749475fdb00d098e4f08ace4c56c23b2f6a2f4e2e82ce6f3f5b0"
    sha256 cellar: :any, arm64_ventura:  "b6ff62222cae0cab0df03f03edc42abf00062ef11ab97cdb847cc89b6f2a70f3"
    sha256 cellar: :any, arm64_monterey: "5df526faf2300c6065cffef6878086594398d8a651a11cbf9cb107eb0cf05ebe"
    sha256 cellar: :any, sonoma:         "f4dadb09517e41e8d68c69ce1f3507e3f1a1e75d1f5b304229b44e4f991f767a"
    sha256 cellar: :any, ventura:        "15a236051dd33bc086004f44b6cc7e607f5d9a84af20f1720f0ac9d731890290"
    sha256 cellar: :any, monterey:       "edde70d3b868f6481de4c83eb8d7903f72c89983ce3ef7e99768706348537366"
    sha256               x86_64_linux:   "9def1cf7f369fd27399f3621f90e54909e03177fd1f8adfae6cae3173ff5e8eb"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
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
      system python, "-m", "pip", "install", *std_pip_args,
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
