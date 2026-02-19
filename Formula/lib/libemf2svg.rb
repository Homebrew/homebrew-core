class Libemf2svg < Formula
  desc "Microsoft (MS) EMF to SVG conversion library"
  homepage "https://github.com/kakwa/libemf2svg"
  url "https://github.com/kakwa/libemf2svg/archive/refs/tags/1.8.1.tar.gz"
  sha256 "5a4b0051a2e8a7f999ecc1bb3451032833dc4c4f1e4bc6d938e4d5b4bec19c10"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b097e6912f5088e54da1fd430b2dc6c990267cf5adeaef50027b6731d8850849"
    sha256 cellar: :any,                 arm64_sequoia: "0e6713d4805a1b5de0ddbfc4bf67168cf81d8ed6ab93292e74f33cb39eeec34f"
    sha256 cellar: :any,                 arm64_sonoma:  "3b929447d8efd14e896683ef6efaa7e9a90fbcc105353f2adb6e2f0c5b2ff0aa"
    sha256 cellar: :any,                 sonoma:        "43ca789862051ce4d6f4efad49c7ad5a376c71db49c1af363d64848dd5ab652d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5e0714ac651f7c10cf98b5d40c08996a731eb3c127d9f18738ce6096378f35d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63881c05d28fbb48bb25d3aa7272d12524357cb69b4657862b24a17b36c13835"
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "argp-standalone" => :build
  end

  def install
    # Bypass to check brew setup
    # https://github.com/kakwa/libemf2svg/issues/50
    inreplace "CMakeLists.txt", "Darwin", "PASS" if OS.mac?

    args = %W[-DCMAKE_INSTALL_RPATH=#{rpath}]
    args << "-DEXTERNAL_ICONV=iconv" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/kakwa/libemf2svg/raw/1.1.0/tests/resources/emf/test-037.emf"
      sha256 "d2855fc380fc3f791da58a78937af60c77ea437b749702a90652615019a5abdf"
    end

    resource("homebrew-testdata").stage do
      system bin/"emf2svg-conv", "-i", "test-037.emf", "-o", testpath/"test.svg"
    end
    assert_path_exists testpath/"test.svg"
  end
end
