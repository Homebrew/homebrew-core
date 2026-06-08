class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_130.tar.gz"
  sha256 "20d727e7f3011cfe604b8ebdc873edbb4831c6b148209cb15bc2bedcded036ee"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-](\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e52b96c270f249b401b93534ad4b4c9354decbad56fc6ae7e19c545bf3a5b826"
    sha256 cellar: :any, arm64_sequoia: "9c12bb864df5a2b0171006973ec103226d442b8975c507e2e2babbe317c9cbd9"
    sha256 cellar: :any, arm64_sonoma:  "986b318e8ea118863634f40be604fabbb343047561cf91f631bc01e788a39a09"
    sha256 cellar: :any, sonoma:        "d6981b50229871db75eb5205ac50a79deacabce02b6b8f1ec0bf1d5141c60d9f"
    sha256 cellar: :any, arm64_linux:   "661e78af99e8e0391843e90fb4a8a85737d7411b67a3f2e4eddee058f56bb81d"
    sha256 cellar: :any, x86_64_linux:  "2dcdac798f8d62ef984630c0001e36ad258288fb07e0d870ed3d0fe1d25eb775"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTS=false", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test/"
  end

  test do
    system bin/"wasm-opt", "-O", pkgshare/"test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", (testpath/"1.wast").read
  end
end
