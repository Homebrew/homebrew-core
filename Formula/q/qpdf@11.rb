class QpdfAT11 < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.10.1/qpdf-11.10.1.tar.gz"
  sha256 "defca435cf57d26f8a0619864841aa21f5469fddc6eb5662f62d8443021c069d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1e038e1c17d7593c41d5971eff18e7510d1efafc3b60839467c2550079a65d30"
    sha256 cellar: :any,                 arm64_sonoma:  "18d4d89c87492f32ed836f306097cf06f093e7b221d505a815878647001be4d2"
    sha256 cellar: :any,                 arm64_ventura: "2300bcf8a73a671839b72555c67953d1b36d2af87c4e75459279edf2e337e8a7"
    sha256 cellar: :any,                 sonoma:        "dd1ee4a66287745cbc12abc120425d98b56f7efa80be7e70b1ca996a20b0ff8e"
    sha256 cellar: :any,                 ventura:       "f4d84d400a1378795f947c42993f0fe58b24d2dd2523a7f9d39a1da2880470a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33ba8bd0a4b41646a4bd54a51e1cc93a6de3827061846d16e44434a7975b4d20"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_IMPLICIT_CRYPTO=0",
                    "-DREQUIRE_CRYPTO_OPENSSL=1",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"qpdf", "--version"
  end
end
