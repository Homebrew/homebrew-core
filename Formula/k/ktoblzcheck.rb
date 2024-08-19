class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "https://ktoblzcheck.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.57.tar.gz"
  sha256 "4c3b782e5d8e31e219c3e2ece0c6e84a93929ae0b2f36080d4c183a644d05672"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ktoblzcheck[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "084776ea34dcc4ae3e571bd5383ef29e7e62b4851353fd0e86d4ae8ae301bf2b"
    sha256 arm64_ventura:  "9af95c7e3d1c66ca99021731dbccb96c5c5450f6e9b34eb2591a961dd113e4b8"
    sha256 arm64_monterey: "8cf9571be81238bcb9f03425b18f4674f0651f6718163ed1be21c4dac77d106a"
    sha256 sonoma:         "07eddef8c57584634aad419540f66b3357fe59d5f37cf131c5d2ac39e8367ae3"
    sha256 ventura:        "fec0eeac965d49ed688e5892f7a1cef56b60a9356c90ecf271897b6e2ea81492"
    sha256 monterey:       "4e6add3a4d5280adcba9a36535ce9ecfe575d3b02a48df2fddb8716a03d1d4f7"
    sha256 x86_64_linux:   "5459b890356bfc72a4a413ebacbd08eba0562af0bb2583cb5587a9b4a07f4d2d"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12"
  depends_on "sqlite"

  uses_from_macos "curl"

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/3d/5d/0413a31d184a20c763ad741cc7852a659bf15094c24840c5bdd1754765cd/et_xmlfile-1.1.0.tar.gz"
    sha256 "8eb9e2bc2f8c97e37a2dc85a09ecdcdec9d8a396530a6d5a33b30b9a92da0c5c"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/42/e8/af028681d493814ca9c2ff8106fc62a4a32e4e0ae14602c2a98fc7b741c8/openpyxl-3.1.2.tar.gz"
    sha256 "a6f5977418eff3b2d5500d54d9db50c8277a368436f4e4f8ddb1be3422870184"
  end

  def python3
    "python3.12"
  end

  def install
    ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)
    resources.each do |r|
      r.stage do
        system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
      end
    end

    # Work around to help Python bindings find shared library on macOS.
    # OSError: dlopen(ktoblzcheck, 0x0006): tried: 'ktoblzcheck' (no such file), ...
    # OSError: dlopen(libktoblzcheck.so.1, 0x0006): tried: 'libktoblzcheck.so.1' (no such file), ...
    inreplace "src/python/ktoblzcheck.py", /'libktoblzcheck\.so\.(\d+)'/, "'libktoblzcheck.\\1.dylib'" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{opt_lib}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Ok", shell_output("#{bin}/ktoblzcheck --outformat=oneline 10000000 123456789")
    assert_match "unknown", shell_output("#{bin}/ktoblzcheck --outformat=oneline 12345678 100000000", 3)
    system python3, "-c", "import ktoblzcheck"
  end
end
