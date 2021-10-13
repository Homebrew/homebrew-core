class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/90/d4/a7c9b6c5d176654aa3dbccbfd0be4fd3a263355dc24122a5f1937bdc2689/Pillow-8.3.2.tar.gz"
  sha256 "dde3f3ed8d00c72631bc19cbfff8ad3b6215062a5eed402381ad365f82f0c18c"
  license "HPND"
  revision 1
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a90fc7a42c2c4ceb7b316f5a1784cab67d4e07c39a8a0a5e3665ad11ac06c9e8"
    sha256 cellar: :any, big_sur:       "c3769c542fbc2c9ac13118b593686c6a517c62745707ed5f227368d86ec396fa"
    sha256 cellar: :any, catalina:      "7ec1f2846bee7cbeda992605513d93825fe5427145afb0868ebbb62454e753b7"
    sha256 cellar: :any, mojave:        "063b73280a067fbf606bb161d6664b14d008a0878db0fb2e4a416ad4cd73efb3"
    sha256               x86_64_linux:  "519b880afb7bc3d0e17821b2b27e76849b8efbaf11a25a4486492fdd96ae8c3c"
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
