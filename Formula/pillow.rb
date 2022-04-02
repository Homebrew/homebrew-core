class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/4b/83/090146d7871d90a2643d469c319c1d014e41b315ab5cf0f8b4b6a764ef31/Pillow-9.1.0.tar.gz"
  sha256 "f401ed2bbb155e1ade150ccc63db1a4f6c1909d3d378f7d1235a44e90d75fb97"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "3258034d4ca51ba3539193eac70f6792d37b40769d8a16410dfc6c435fb8f9f5"
    sha256 cellar: :any, arm64_big_sur:  "dce572358d1aa2baeaaa2c8e3cefd59a6c624b7bb1957180ee0f5036a8779897"
    sha256 cellar: :any, monterey:       "bd08af4f2377fad8558a30d02c9a4d7ad4e203f83bdd7c8a6790e73cda9b8d0c"
    sha256 cellar: :any, big_sur:        "85b2e6d513941be9e0fc11d60e35e328cfca9b3623e94ef94cca1707f111504b"
    sha256 cellar: :any, catalina:       "17d9d1a02e75d7e46493a4c44f18ca05a837a441d20d2429927bcc4b3dc4e073"
    sha256               x86_64_linux:   "fa5171991e534c0bed021c737f83bccce015e1e2aea29069ff9924aa99323a77"
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
