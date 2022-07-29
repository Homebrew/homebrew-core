class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/8c/92/2975b464d9926dc667020ed1abfa6276e68c3571dcb77e43347e15ee9eed/Pillow-9.2.0.tar.gz"
  sha256 "75e636fd3e0fb872693f23ccb8a5ff2cd578801251f3a4f6854c6a5d437d3c04"
  license "HPND"
  revision 1
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "1e711fdd9a6037ef3b5c38a7315a8abf348ca6d37c158c28c29e5ee44299e395"
    sha256 cellar: :any, arm64_big_sur:  "0405a844258ef3936071721cd469d208fe26a7555ddcc9c937f00592f1ee1bc9"
    sha256 cellar: :any, monterey:       "6cdb4abb1233c3d0027b7fc5f65d6fcd34bcbff24ebad5a5354bb74bd38f7725"
    sha256 cellar: :any, big_sur:        "480b975ceb439446c5a5e290377ebee8fd2e254d2ce01b967f9145a97f08393f"
    sha256 cellar: :any, catalina:       "e4000316af483495b4005f455bd23c104771de896b20f82103e9514267fd7630"
    sha256               x86_64_linux:   "d0a95895bbf1eb40225fc217f9d9258c9c8d13840acf30c986a67d904a4e0dbe"
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
