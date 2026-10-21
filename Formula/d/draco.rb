class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/refs/tags/1.5.9.tar.gz"
  sha256 "5b84e0e212ccc7b03ace681760a65a66fe2481a5f54df65154cfc8f0cbb87148"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7f205e9b9a4565fa0a4e7b7028fc12fc0218859ca47616ff25b5b1d91ae3af87"
    sha256 cellar: :any, arm64_tahoe:       "1b99931105dd24c8722c4b0aa60af834afb73f8fc1f437b4d6d3fc2f8925e218"
    sha256 cellar: :any, arm64_sequoia:     "4e1ffb8ea4289615cbaabdc48ab37d0292528118fca630a53ef75951f7917f43"
    sha256 cellar: :any, arm64_linux:       "be0317ca7678eec139ecf0d8b1f5279b2f3967f49ed72669b6eb1043c2ba49b3"
    sha256 cellar: :any, x86_64_linux:      "602821e32976b8986c73f1446f1e096c095ccf89f64bc518342c63c0aa7fa22c"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "testdata/cube_att.ply"
  end

  test do
    cp pkgshare/"cube_att.ply", testpath

    output = shell_output("#{bin}/draco_encoder -i cube_att.ply -o cube_att.drc")
    assert_path_exists testpath/"cube_att.drc"
    assert_match <<~EOS, output
      Encoder options:
        Compression level = 7
        Positions: Quantization = 11 bits
        Normals: Quantization = 8 bits
    EOS
  end
end
