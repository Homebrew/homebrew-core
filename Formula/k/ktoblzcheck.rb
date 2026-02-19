class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "https://ktoblzcheck.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.59.tar.gz"
  sha256 "3cd33880d2425e8fa3be9918c85485514f53e04b0b986bcf7bd003fc53071fa7"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ktoblzcheck[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "fd3b80a2358a2209b506a196e10769ebeed04e5c1f209cd3477ab441e8df9a81"
    sha256 arm64_sequoia: "043fa8fbe400df633dd3beacdf4ed6337ac85827283046f7bd53da22ba1295a7"
    sha256 arm64_sonoma:  "2d85d263b39c318a8d57c14387b548e94b23d98a65632bf3f325f53bcb55e20d"
    sha256 sonoma:        "0b845c7b179e99f6f35fc241922c77a4aefd4adeee544f429ce78c7d79704b48"
    sha256 arm64_linux:   "0ba4ead313ea8f1e5c8d56782ab6a359147328c46ac46ce2f41ae9ccd3f07cd0"
    sha256 x86_64_linux:  "5b7681ef9f5b3de8ccb35f9215651650adfe73ba07b69eac0642ad6ba29aa876"
  end

  depends_on "cmake" => :build
  depends_on "python@3.14"
  depends_on "sqlite"

  uses_from_macos "curl"

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/d3/38/af70d7ab1ae9d4da450eeec1fa3918940a5fafb9055e934af8d6eb0c2313/et_xmlfile-2.0.0.tar.gz"
    sha256 "dab3f4764309081ce75662649be815c4c9081e88f0837825f90fd28317d4da54"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/3d/f9/88d94a75de065ea32619465d2f77b29a0469500e99012523b91cc4141cd1/openpyxl-3.1.5.tar.gz"
    sha256 "cf0e3cf56142039133628b5acffe8ef0c12bc902d2aadd3e0fe5878dc08d1050"
  end

  # Bankdata resource
  resource "ktoblzcheck-data" do
    url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-data-20250515.tar.gz"
    sha256 "307479cd3c487ba6d6c4f5966634a6023c1f29d4386b93a5e96cea7541bebe4c"
  end

  def python3
    "python3.14"
  end

  def install
    ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)
    resources.each do |r|
      next if r.name == "ktoblzcheck-data"

      r.stage do
        system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath, build_isolation: true), "."
      end
    end

    resource("ktoblzcheck-data").stage do
      system "cmake", "-S", ".", "-B", "data", *std_cmake_args
      system "cmake", "--build", "data"
      system "cmake", "--install", "data"

      # Move built bankdata to the path of bankdata for `ktoblzcheck`
      (buildpath/"src/bankdata").install "data"
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
