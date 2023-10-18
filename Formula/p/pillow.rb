class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/80/d7/c4b258c9098b469c4a4e77b0a99b5f4fd21e359c2e486c977d231f52fc71/Pillow-10.1.0.tar.gz"
  sha256 "e6bf8de6c36ed96c86ea3b6e1d5273c53f46ef518a062464cd7ef5dd2cf92e38"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "53af893ab6b9e369162cee379f4d0ffeb6638656aa68f4bc4701e4b07236aae9"
    sha256 cellar: :any, arm64_ventura:  "a6d4ad8b0e295a6b7ad0478f7ac28ba7181763b92c92586beddb21e48c1e7d29"
    sha256 cellar: :any, arm64_monterey: "b53ca2c8c450f2ff524873246dd5c8f8a29be1934a594de258065e820f3b621d"
    sha256 cellar: :any, sonoma:         "0fe8b6a662ded558291556073096a23a2cab69a457a82fc582255a9339568daf"
    sha256 cellar: :any, ventura:        "ce59a424c06c3fc0ce504e0cfa18976104a39992d218cdc4763cc86ffe882521"
    sha256 cellar: :any, monterey:       "2782c20eb0b7c7775fff3f7e6c52de7c5a18639b5172c643932779155f4c97dc"
    sha256               x86_64_linux:   "1b29cd93fdeaa3c99feb05a90e154c875ec8cb33d4bd29f368850832b607a4c0"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
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
