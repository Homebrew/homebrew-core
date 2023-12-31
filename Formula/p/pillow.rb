class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/80/d7/c4b258c9098b469c4a4e77b0a99b5f4fd21e359c2e486c977d231f52fc71/Pillow-10.1.0.tar.gz"
  sha256 "e6bf8de6c36ed96c86ea3b6e1d5273c53f46ef518a062464cd7ef5dd2cf92e38"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "180cd034f3446c0d2933c7fbb31a95aba9b4bfadf430857caa36a39431601cf3"
    sha256 cellar: :any, arm64_ventura:  "e7c413b9395c90b3cca3859f9e317860db3b7674acd7f2b874cc1bade0d8897b"
    sha256 cellar: :any, arm64_monterey: "168419748162fbfc565836ed6216174a385c89805fb3e2ae50757a42566b9557"
    sha256 cellar: :any, sonoma:         "8dbba92e0e8024704d0d453d3566a9012463634b69978edfdcafad9e4b78f2b4"
    sha256 cellar: :any, ventura:        "e201d9b0025b082c0d8b22b0653195eb6d0e7e57870bdf41343453df075ba59f"
    sha256 cellar: :any, monterey:       "f6d524d94dbfaef98b62ab6169c24d3fc1ce3a18ef3f574b52a8232db92d3d7f"
    sha256               x86_64_linux:   "0751683c3c522416361138686b3ee37848faadf53189edaec48b0f31f971d3fc"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
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
    ENV["MAX_CONCURRENCY"] = ENV.make_jobs.to_s
    deps.each do |dep|
      next if dep.build? || dep.test?

      ENV.prepend "CPPFLAGS", "-I#{dep.to_formula.opt_include}"
      ENV.prepend "LDFLAGS", "-L#{dep.to_formula.opt_lib}"
    end

    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args,
                     "-C", "debug=true", # Useful in case of build failures.
                     "-C", "tiff=enable",
                     "-C", "freetype=enable",
                     "-C", "lcms=enable",
                     "-C", "webp=enable",
                     "-C", "xcb=enable",
                     "."
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
