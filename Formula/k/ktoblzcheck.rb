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
    rebuild 2
    sha256 arm64_golden_gate: "e62bc704239383a34267beb55fce405d2a8c2f7b006c2cc2758716ba1deffd54"
    sha256 arm64_tahoe:       "bfb13def3ffbf8b7d1169bda69a633268bcc40f76f1156851759bc8addeffa57"
    sha256 arm64_sequoia:     "edc711ab543ecbc5f5d2ad7b16b5233ce548e4533414a67631757740f2aa2876"
    sha256 arm64_linux:       "81cd7bdfeb35ea839d1ec02702f8de8b98be40d8187c01114e8838bf60068d41"
    sha256 x86_64_linux:      "d4540f3862230bcc48647ad02ce00047929412e6a2357c7aab9266d3bd08288a"
  end

  depends_on "cmake" => :build
  depends_on "python@3.15"
  depends_on "sqlite"

  uses_from_macos "curl"

  pypi_packages package_name:   "",
                extra_packages: "openpyxl"

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

    livecheck do
      url :url
      regex(/url=.*?ktoblzcheck-data[._-]v?(\d+(?:\.\d+)*)\.t/i)
    end
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
