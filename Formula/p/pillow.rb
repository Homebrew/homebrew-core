class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.github.io/"
  url "https://files.pythonhosted.org/packages/f3/0d/d0d6dea55cd152ce3d6767bb38a8fc10e33796ba4ba210cbab9354b6d238/pillow-11.3.0.tar.gz"
  sha256 "3828ee7586cd0b2091b6209e5ad53e20d0649bbe87164a459d0676e035e8f523"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "576d1075766bacbf6f77cdbe3d03d7f2628e5f3d491b7f852fa9b6db68e2eec6"
    sha256 cellar: :any, arm64_sonoma:  "f647fb1968db54b8899989f4beb226e2f0cf645b8549e757f5f9617de9bfad9b"
    sha256 cellar: :any, arm64_ventura: "1e5e7093e09d0b04e689d55e8836238476b85592b46f3a9a50515e4a71796c0b"
    sha256 cellar: :any, sonoma:        "ab3dde3744c9aac75669dcd1b03c7cff74cdeeea292c0d7515a1060c389134df"
    sha256 cellar: :any, ventura:       "eec25e16e31d90eb0862521401fb218f7a33f207ed3b990187b0a8f103d071f8"
    sha256               arm64_linux:   "c015db6c8d20b536700acc9c6dec5068a3f37a5ececb0a86aead2954996a3f93"
    sha256               x86_64_linux:  "0a57aa1edc9c3dbf8c4016f3cbca34222109fc1764dacf860e385b61e248e269"
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
