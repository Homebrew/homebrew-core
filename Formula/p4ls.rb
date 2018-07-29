class P4ls < Formula
  desc "LSP server for P4 language"
  homepage "https://github.com/dmakarov/p4ls"
  url "https://github.com/dmakarov/p4ls/releases/download/v0.1/p4ls-0.1.tar.gz"
  sha256 "e45dc78a47f07fc2effec9a630d8cdd3bb67330277a8495eb32f054245cd43ce"
  head "https://github.com/dmakarov/p4ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4c10b1c2b2a62a6242fb88daf5dfb771048d9252c49f5fe7dbd5f32ab40a6ae" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "rapidjson" => :build
  depends_on "gmp"

  def install
    args = std_cmake_args
    args << "-DENABLE_GC=OFF"
    args << "-DENABLE_BMV2=OFF"
    args << "-DENABLE_EBPF=OFF"
    args << "-DENABLE_GTESTS=OFF"
    args << "-DENABLE_P4C_GRAPHS=OFF"
    args << "-DENABLE_P4TEST=OFF"
    args << "-DHUNTER_ENABLED=OFF"
    args << "-DBoost_USE_STATIC_LIBS=ON"
    args << ".."
    mkdir "build" do
      system "cmake", "-G", "Ninja", *args
      system "cmake", "--build", ".", "--target", "src/tool/install"
    end
  end

  test do
    system "#{bin}/p4lsd", "-v"
  end
end
