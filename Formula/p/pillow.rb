class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/64/9e/7e638579cce7dc346632f020914141a164a872be813481f058883ee8d421/Pillow-10.0.1.tar.gz"
  sha256 "d72967b06be9300fed5cfbc8b5bafceec48bf7cdc7dab66b1d2549035287191d"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "7eee4d1276afc4778d94d7919d8464734557147eb20d45add172919777c2cb1a"
    sha256 cellar: :any, arm64_monterey: "2fbcf1e5c7b95bd95b3fae2d8e6792ad900f2fb3c80a9dc54ccb2fab4ceb7e09"
    sha256 cellar: :any, arm64_big_sur:  "a28b027f4d81d4eb79eb9fd19da26509c9507a1ba40f0efe62df3a5597d6c2b1"
    sha256 cellar: :any, ventura:        "824e42d946c0a7d005d2556df49a7ef4e825b1ce5212564975352a50df95aa33"
    sha256 cellar: :any, monterey:       "391282c5551f1e990075e99512316e57aa5f419b3b3116c284d3f20d180848e1"
    sha256 cellar: :any, big_sur:        "3f16ab869d42bcd2eaaf39bef2218e9d820d3e7efd4ff54c75e236725d81c726"
    sha256               x86_64_linux:   "0e0efd9b1973d8e8e1b94944531d7d266fbf4613e6e5bfc9d120948c70ff0346"
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
