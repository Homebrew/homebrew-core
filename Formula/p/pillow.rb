class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.github.io/"
  url "https://files.pythonhosted.org/packages/af/cb/bb5c01fcd2a69335b86c22142b2bccfc3464087efb7fd382eee5ffc7fdf7/pillow-11.2.1.tar.gz"
  sha256 "a64dd61998416367b7ef979b73d3a85853ba9bec4c2925f74e588879a58716b6"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "4795f66c54ecabe2ff51bac254ddd4d928b8a39a876a032f4c2beb256ca45d13"
    sha256 cellar: :any, arm64_sonoma:  "83db61f72687352e8bffc56fa0ddfadbe8bae693465903ba39cfbd704d9f0788"
    sha256 cellar: :any, arm64_ventura: "bde65e4cd9b46783baa63f524890ac05fbfca173a37eaf55d4dd5071e094d02c"
    sha256 cellar: :any, sonoma:        "753a0e4f8ad99015b2eecddc0b2f487ec1728457b5c1dc2ec43ef497a682a413"
    sha256 cellar: :any, ventura:       "696e9a6bf06b41ef627a78ad56a61bc9c810791b1d61c358d1b19474b54f5609"
    sha256               arm64_linux:   "98f94cdcaa3aacd87fc53c638e92629a9d6a351db69ad2211568f9c78b739fd5"
    sha256               x86_64_linux:  "beade070b75c473a215372cb8bc41ec9aba0919c3fa09a66f1def1fc3881687a"
  end

  depends_on "pkgconf" => :build
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
    (testpath/"test.py").write <<~PYTHON
      from PIL import Image
      im = Image.open("#{test_fixtures("test.jpg")}")
      print(im.format, im.size, im.mode)
    PYTHON

    pythons.each do |python|
      assert_equal "JPEG (1, 1) RGB", shell_output("#{python} test.py").chomp
    end
  end
end
