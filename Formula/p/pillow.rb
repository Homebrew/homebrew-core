class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/ef/43/c50c17c5f7d438e836c169e343695534c38c77f60e7c90389bd77981bc21/pillow-10.3.0.tar.gz"
  sha256 "9d2455fbf44c914840c793e89aa82d0e1763a14253a000743719ae5946814b2d"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "0d273664ae000b009f9aeb69c0b09f673007ed189f7506363a1a689a2b7a9e35"
    sha256 cellar: :any, arm64_ventura:  "84baf638230dfb24e7ba99fcfeb8cbeef5efb103a581f019252b607c75c3452e"
    sha256 cellar: :any, arm64_monterey: "a10c3f9ba4e3aac3812f7d55652bf74d11e5e2e5f97916e51b0d636932dbacbf"
    sha256 cellar: :any, sonoma:         "52a584939e08db863a1e2acb0c7e9c8299a9a6bac0cac9727437e65805b3aa74"
    sha256 cellar: :any, ventura:        "b0f7e607dd615f43119fd3f8e0757781f4907b08ae533da91ad68d302de8b4ad"
    sha256 cellar: :any, monterey:       "deeb9d8eb036933ea38c0d601fa6295249ad79416c9d6726b1546e360cc26713"
    sha256               x86_64_linux:   "58d2c263096df862e5bdfe0b6b103a3eb0adfc4ceae65d2a2ccb5c23ac0d41c0"
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
