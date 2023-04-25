class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/00/d5/4903f310765e0ff2b8e91ffe55031ac6af77d982f0156061e20a4d1a8b2d/Pillow-9.5.0.tar.gz"
  sha256 "bf548479d336726d7a0eceb6e767e179fbde37833ae42794602631a070d630f1"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "9a6111105f8050c03920b772944ea9e93e4aa23f5c67af94f53f1dc810a381ad"
    sha256 cellar: :any, arm64_monterey: "7ef2c89f4e39b95f73c3dc99fa5657bf339601f83493040a10bf2df7aad2d89a"
    sha256 cellar: :any, arm64_big_sur:  "ae364214858a1e1737bb24000dff4baac822827e4c96fe7b280d7676f3663dd6"
    sha256 cellar: :any, ventura:        "423eb1342b2c739a0419ee5d85d7aae029e6def4af49af78703239a62e6f057a"
    sha256 cellar: :any, monterey:       "502d73f568c4f32b5c7f8f9dcda05040c146692e5d72b610bd627994ae64b94b"
    sha256 cellar: :any, big_sur:        "d9e4db3d23cefea35a83aed0748dac5d5cd345e9e24d1dd1c10f68338d797eb2"
    sha256               x86_64_linux:   "d0398859771b22b2db06ab7c5ad014358234c89691301f8b501087ce9b4d7aa6"
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
