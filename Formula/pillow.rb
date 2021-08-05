class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/8f/7d/1e9c2d8989c209edfd10f878da1af956059a1caab498e5bc34fa11b83f71/Pillow-8.3.1.tar.gz"
  sha256 "2cac53839bfc5cece8fdbe7f084d5e3ee61e1303cccc86511d351adcb9e2c792"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "503dca80c15baf181b507d10d76217a43afb6a9043a5c821997d11d59a542324"
    sha256 cellar: :any, big_sur:       "f431196fb3a02dd5c37bdf076daea8a56f214d6123146627a1dfa3f9f0b03dd9"
    sha256 cellar: :any, catalina:      "e27facb720fb31c1d03e3a1d8dee3f2ebb65607deb16290fb101cd8c24e3f960"
    sha256 cellar: :any, mojave:        "1864ce64006f862444bc498e031d3f3b4258644b7387546491cfd9e6f5be81f5"
    sha256               x86_64_linux:  "fd8454a24ddf90269d840a522ed79296a901c3f5d00e8aa10926a57f4b978751"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.8" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "jpeg"
  depends_on "libimagequant"
  depends_on "libraqm"
  depends_on "libtiff"
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
    pre_args = %w[
      --enable-tiff
      --enable-freetype
      --enable-lcms
      --enable-webp
      --enable-xcb
    ]

    post_args = %W[
      --prefix=#{prefix}
      --install-scripts=#{bin}
      --single-version-externally-managed
      --record=installed.txt
    ]

    ENV["MAX_CONCURRENCY"] = ENV.make_jobs.to_s
    ENV.prepend "CPPFLAGS", "-I#{Formula["tcl-tk"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["tcl-tk"].opt_lib}"

    pythons.each do |python|
      system python, "setup.py", "build_ext", *pre_args, "install", *post_args
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
