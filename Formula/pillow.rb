class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/0f/8b/2ebaf9adcf4260c00f842154865f8730cf745906aa5dd499141fb6063e26/Pillow-10.0.0.tar.gz"
  sha256 "9c82b5b3e043c7af0d95792d0d20ccf68f61a1fec6b3530e718b688422727396"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "1c157280a9671e1d4e1fd12d021bcb755d739cff061e0725468ce6e6f19e7192"
    sha256 cellar: :any, arm64_monterey: "e6190bafe6c6b0e0b1327b547603591e799af07cd9fc42dd26ddb1c709ae0c83"
    sha256 cellar: :any, arm64_big_sur:  "7a3df0ffdfa7e641a01423b32720c541a95c39e78396f6b2afc60328489a851a"
    sha256 cellar: :any, ventura:        "c813fb7d7f03c9426a6a4b22b4b8e49abd6c99a6f1defd48b25b6caee09aa631"
    sha256 cellar: :any, monterey:       "6b96d00be21890f5229cdb4e0b3f89c104a8730c3c381f987526736a437780f0"
    sha256 cellar: :any, big_sur:        "35e7b1beade031a529ffab554714031a4f849fe94c8ac89a844e7ad1fb12a7b1"
    sha256               x86_64_linux:   "38925f18bdb9b7d60d9be4ff6ca674943ec4f1058dbc81ee82987b8d2a4b9111"
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
