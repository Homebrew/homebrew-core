class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/7d/2a/2fc11b54e2742db06297f7fa7f420a0e3069fdcf0e4b57dfec33f0b08622/Pillow-8.4.0.tar.gz"
  sha256 "b8e2f83c56e141920c39464b852de3719dfbfb6e3c99a2d8da0edf4fb33176ed"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "5b957e5afdd859268f4451665d142f7b8a1ed9186f6b36f22fe901891affa2dd"
    sha256 cellar: :any, arm64_big_sur:  "b3ef0a8ef99c29d197ff4735a75d5dfcd7dba93d85f6957367da187b65fb5a3d"
    sha256 cellar: :any, monterey:       "b5ca0c6fb4391f2d9e5e9f5d6984b034b0ccf0051225524ccf029c0ad5cd44e2"
    sha256 cellar: :any, big_sur:        "59e29e62a00a1a7c743af405f5ca86919d4a72c266f03498a035e025a6a9e70c"
    sha256 cellar: :any, catalina:       "7d202a4c71e5c3ecd5508e34a89082496441dcf4cbabd47174edaf1c6fb06dd8"
    sha256 cellar: :any, mojave:         "7d9654f09ff31d8caf4363b25a11da203cd3c2725014fdbb8df6e1a7a9a91399"
    sha256               x86_64_linux:   "af8b0493c459338a4cc5f7ac4a8bc6a88cee2640577e142557524e039accaa2e"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
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
