class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/4b/83/090146d7871d90a2643d469c319c1d014e41b315ab5cf0f8b4b6a764ef31/Pillow-9.1.0.tar.gz"
  sha256 "f401ed2bbb155e1ade150ccc63db1a4f6c1909d3d378f7d1235a44e90d75fb97"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "6176dcb9125b2a6c7b336c127e9683b2e29eb46c685f8f1b79ada91833e9da6f"
    sha256 cellar: :any, arm64_big_sur:  "5fd9a913c277c151ae2b406c522909dcc8e64feeb44e71901b65cf1c7a8badcf"
    sha256 cellar: :any, monterey:       "f3ad1d785722ef68927e4351598d8cf38d7a74237800a095a3f5dc9199bf10b8"
    sha256 cellar: :any, big_sur:        "9f8eb1e32bbc3756e8ba32b41cf59ad3c992636469711e24942c063e01ec8374"
    sha256 cellar: :any, catalina:       "93251029746eefa384bd9252cf0ea1baa43cdfb13af0daaae22d5f8c6841c57c"
    sha256               x86_64_linux:   "42d6d1cc8de6daefdef4797b8b42d3afe54e0e559d10ccbe2b01909cee925620"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.8" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "jpeg"
  depends_on "libimagequant"
  depends_on "libraqm"
  depends_on "libtiff"
  depends_on "libxcb"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "tcl-tk"
  depends_on "webp"

  uses_from_macos "zlib"

  on_macos do
    depends_on "python@3.7" => [:build, :test] unless Hardware::CPU.arm?
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/python@\d\.\d+/) }
        .map(&:opt_bin)
        .map { |bin| bin/"python3" }
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
      system python, "setup.py",
                     "build_ext", *build_ext_args,
                     "install", *install_args, "--install-lib=#{prefix/Language::Python.site_packages(python)}"
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
