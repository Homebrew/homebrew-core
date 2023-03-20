class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/bc/07/830784e061fb94d67649f3e438ff63cfb902dec6d48ac75aeaaac7c7c30e/Pillow-9.4.0.tar.gz"
  sha256 "a1c2d7780448eb93fbcc3789bf3916aa5720d942e37945f4056680317f1cd23e"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "978764003b8b3af314360d4511779efc2f315f80258e7c778ea375163a1a81a9"
    sha256 cellar: :any, arm64_monterey: "f9b121a6ad05020f68454c86c47934253e6bbe49fb9e189715e5f38ddf31e9bc"
    sha256 cellar: :any, arm64_big_sur:  "074f7275147ee30fc533392754ad05ae84eb9e22db0d0f28d2780959b6589338"
    sha256 cellar: :any, ventura:        "8a6b048856c143eafaa7264f8357b1aba9a2a79e44934ba8d2cb3a6b008850a6"
    sha256 cellar: :any, monterey:       "c1ae6fdc15e381983e671219508adb6003bfa0869b0268491dd94267c9f91d38"
    sha256 cellar: :any, big_sur:        "54b3c916ea6ffb7179b68647f64111918b90ec06594d7ad37daf80d616bdd87e"
    sha256               x86_64_linux:   "33ced412bf6d643ff41f12abc1d028aec93ded788a8865e73db7e84fc56c7e05"
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
