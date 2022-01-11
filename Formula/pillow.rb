class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/b0/43/3e286c93b9fa20e233d53532cc419b5aad8a468d91065dbef4c846058834/Pillow-9.0.0.tar.gz"
  sha256 "ee6e2963e92762923956fe5d3479b1fdc3b76c83f290aad131a2f98c3df0593e"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "ccd9d22e4471abdd8c6a81309b8ed313e71f26eaa0edae7f1ab3e4e76cd86224"
    sha256 cellar: :any, arm64_big_sur:  "d70f9c21e1d0830b373c3df2ed319f849ea53f405dbe8fa977b9c1c0a3ba434d"
    sha256 cellar: :any, monterey:       "be5c26a11865575cb902745f01b4012cdae63a388503cb514ead037eab4dd0f7"
    sha256 cellar: :any, big_sur:        "ee2f117d7136ecedaef3595f0aa96b0d7a8d26be89887d8e012464cef9bdb397"
    sha256 cellar: :any, catalina:       "9a95ca0b087091386d5f87e0f2e3095abb36bce73aa8b6540d6fd16c725f6553"
    sha256               x86_64_linux:   "ae48d33496be433465650ff0d981b9344f86a11d74b3e0382f616c474a50fa56"
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
