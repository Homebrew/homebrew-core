class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/a5/26/0d95c04c868f6bdb0c447e3ee2de5564411845e36a858cfd63766bc7b563/pillow-11.0.0.tar.gz"
  sha256 "72bacbaf24ac003fea9bff9837d1eedb6088758d41e100c1552930151f677739"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "e1022c34f56ee10daf647e70fd3305c2653718bf78c0cd89dffe23d29873c24a"
    sha256 cellar: :any, arm64_sonoma:  "148cc0c608021690b06360208e525f2606abfd50dafd0d14322bfbfc44da6a38"
    sha256 cellar: :any, arm64_ventura: "3718c3be4bd1d28965815082d32f59d89ca3c0c6a001797c13ebe43bbab539ee"
    sha256 cellar: :any, sonoma:        "83f710a136956297d32039e22be79d12612cc6b254910d1834f3554390971f79"
    sha256 cellar: :any, ventura:       "527c15b9d868eae0cfa0b60d4affb0b76441c9194f34d60eb58619cbad644665"
    sha256               x86_64_linux:  "e7a618cba484da3cb05fcaec9d300cde908124f17d3d82c1a69dbe54b782fca0"
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
