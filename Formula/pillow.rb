class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/16/11/da8d395299ca166aa56d9436e26fe8440e5443471de16ccd9a1d06f5993a/Pillow-9.3.0.tar.gz"
  sha256 "c935a22a557a560108d780f9a0fc426dd7459940dc54faa49d83249c8d3e760f"
  license "HPND"
  revision 1
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "74fb00c6613b82b5f07fb122b1eac331a917873f7ef69278bfde0c4aafba568a"
    sha256 cellar: :any, arm64_monterey: "52677d7845bdeb5527bd390af5e098b307403909d7decefea5e4358756e97b84"
    sha256 cellar: :any, arm64_big_sur:  "f7fb3cea71579546a10700bb1da39410067483a178184b5f4cbf08313be88f42"
    sha256 cellar: :any, ventura:        "3ae69dba678e02c10bef796034fdc17475a982578b909b3a7d0af05bb27c912d"
    sha256 cellar: :any, monterey:       "ddd5e92ef50ac3be9df10e2331efab57fc46b55bba8a4fea5181845173cc1c6d"
    sha256 cellar: :any, big_sur:        "a000ad0cf374d660e89d30c2a6994c07afc5c94f015db0a06700fc4a6a89922f"
    sha256 cellar: :any, catalina:       "465b0e189d713ff8d66b655783d9090d9f13733a8bbff0676ec00faff135de80"
    sha256               x86_64_linux:   "a887300e582a3615e8f2d6572e2dc4e36389e8bb412ac6a95d4dde4007e54b32"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
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
    build_ext_args = %w[
      --enable-tiff
      --enable-freetype
      --enable-lcms
      --enable-webp
      --enable-xcb
    ]

    install_args = %w[
      --single-version-externally-managed
      --record=installed.txt
    ]

    ENV["MAX_CONCURRENCY"] = ENV.make_jobs.to_s
    deps.each do |dep|
      next if dep.build? || dep.test?

      ENV.prepend "CPPFLAGS", "-I#{dep.to_formula.opt_include}"
      ENV.prepend "LDFLAGS", "-L#{dep.to_formula.opt_lib}"
    end

    # Useful in case of build failures.
    inreplace "setup.py", "DEBUG = False", "DEBUG = True"

    pythons.each do |python|
      prefix_site_packages = prefix/Language::Python.site_packages(python)
      system python, "setup.py",
                     "build_ext", *build_ext_args,
                     "install", *install_args,
                     "--install-lib=#{prefix_site_packages}"
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
