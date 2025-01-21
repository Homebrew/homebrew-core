class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "96a1ef3d12eb30a950164f203b012b5f2257ef796b9bd15163d9ba3b79a32a1b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "422d44198c78c32942ed61ff8b5aebf6ee7e70ca139d4d5d2948cdfd9da98317"
    sha256 cellar: :any,                 arm64_sonoma:   "b8429e8dfd8e8ed55b43bcbe3303429a15d2198f766161223412a5aac9a26900"
    sha256 cellar: :any,                 arm64_ventura:  "756948a27239a72cd8b6fa312fd4c3cb4fa9f20940c4158011a82e681938f5cd"
    sha256 cellar: :any,                 arm64_monterey: "3c9d3dc8e2768770bd803e6ca8b557295275482df2b57f14b349980ddb7ec678"
    sha256 cellar: :any,                 sonoma:         "ba24de18bcadf148cfc200afc681ab9297e640e2395de69ac43efbe5b4cbf313"
    sha256 cellar: :any,                 ventura:        "ab482d1af11de5e268ad2465ee8feb5aa7436dbc7885cfefa677ab35c39462ef"
    sha256 cellar: :any,                 monterey:       "27da9731aecb9f6f8bf0ce99d8d0719e2f833c9ba7342f784f3b6f952e45eb9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3033bade67d18470af58d50cf498ec6a40cb9f36cccf3a1295d60faa71f7df59"
  end

  depends_on "cmake" => :build
  depends_on "libzip"
  depends_on macos: :mojave

  uses_from_macos "zlib"

  on_linux do
    depends_on "eigen" => :build
  end

  resource "20b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170e-b20c256x2-s5303129600-d1228401921.bin.gz", using: :nounzip
    sha256 "7c8a84ed9ee737e9c7e741a08bf242d63db37b648e7f64942f3a8b1b5101e7c2"
  end

  resource "30b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170-b30c320x2-s4824661760-d1229536699.bin.gz", using: :nounzip
    sha256 "1e601446c870228932d44c8ad25fd527cb7dbf0cf13c3536f5c37cff1993fee6"
  end

  resource "40b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170-b40c256x2-s5095420928-d1229425124.bin.gz", using: :nounzip
    sha256 "2b3a78981d2b6b5fae1cf8972e01bf3e48d2b291bc5e52ef41c9b65c53d59a71"
  end

  def install
    args = ["-DNO_GIT_REVISION=1"]
    args += if OS.mac?
      ["-DUSE_BACKEND=OPENCL", "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}"]
    else
      ["-DUSE_BACKEND=EIGEN"]
    end

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/katago"

    pkgshare.install "cpp/configs"
    pkgshare.install resource("20b-network")
    pkgshare.install resource("30b-network")
    pkgshare.install resource("40b-network")
  end

  test do
    system bin/"katago", "version"
    assert_match(/All tests passed$/, shell_output("#{bin}/katago runtests").strip)
  end
end
