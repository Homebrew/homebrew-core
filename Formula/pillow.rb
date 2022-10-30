class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/16/11/da8d395299ca166aa56d9436e26fe8440e5443471de16ccd9a1d06f5993a/Pillow-9.3.0.tar.gz"
  sha256 "c935a22a557a560108d780f9a0fc426dd7459940dc54faa49d83249c8d3e760f"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "53157e7eff4ed0b13b0265d8c7c92b1ef175be7e56f517837beb9a73817b98ac"
    sha256 cellar: :any, arm64_big_sur:  "944c32d5c73879fabf18783cff43247af60ad91d29bfbbf0c9c36871622ffad1"
    sha256 cellar: :any, monterey:       "180233a30db8b39035e4fe7b6f9ef81210ed679522f62ca7bd3c51db00e9d6a9"
    sha256 cellar: :any, big_sur:        "cd376185b8dbcae5ffc0343dd3a6ed547ec488e4ee6ddfda3e3e6351c6d3d179"
    sha256 cellar: :any, catalina:       "690fc03824f9fdd9e1c96df0ded4e18ab9bbeeff23d0a18ffffa6884b72f16ed"
    sha256               x86_64_linux:   "7f0abd693ed37fedcb55f3bb7a8045d86e376ab2102fb5d53ad290d0c26b8daf"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.8" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
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
