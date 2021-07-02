class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/dc/c2/72349bb3a995fda8f4a064ee5dc92903b21886f27be4f5f1ed8c7b7174e4/Pillow-8.3.0.tar.gz"
  sha256 "803606e206f3e366eea46b1e7ab4dac74cfac770d04de9c35319814e11e47c46"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "edbe60eed19bc463e465538c877749cf3b85196ecaa2279b8bbcdaeaccef3fcc"
    sha256 cellar: :any, big_sur:       "c4782627d43206f0d898a4502de8ce497ab1f785bad5f48407d3e4a6d9a68ee9"
    sha256 cellar: :any, catalina:      "fe025bfeb7f8ff899c01c38b152aeba7256d74c9db811cab958fbbdafce15047"
    sha256 cellar: :any, mojave:        "34815debfe6d381097c5fe36fa94b18a2e5f18b20348eda380378c25070d0497"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.7" => [:build, :test] unless Hardware::CPU.arm?
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
