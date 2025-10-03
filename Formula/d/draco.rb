class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/refs/tags/1.5.7.tar.gz"
  sha256 "bf6b105b79223eab2b86795363dfe5e5356050006a96521477973aba8f036fe1"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2af623d3d7f4f28c7b7c31aad72fbfad20d05cbaa503062854933036c7322ac0"
    sha256 cellar: :any,                 arm64_sequoia: "444b7b20ea990dba3261cfd1fbbb76145321b9d473c90a2801190c4a85cef41c"
    sha256 cellar: :any,                 arm64_sonoma:  "0f361d8c3b0368784f533988d4a44519ef3e82a9ab3a69b2bd98f24282446b66"
    sha256 cellar: :any,                 arm64_ventura: "89bca42ebd075b8d25de0e653a298257e29cd2436405dea7f9f4401bae8a7e95"
    sha256 cellar: :any,                 sonoma:        "7039e3c7e342942f71608d377ea316096701efba166a39c66ff601546bf32f2b"
    sha256 cellar: :any,                 ventura:       "aa05dd53ed7392292a81fc26c93ccc8b1aa99318ce673f817fe9c4204c0820c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5629a81008066774b44c411651acc7f1d1159709dc75c4b64fcf6724bb4c5b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08e5979a2f8db41ee122ecdddb83285038ca417aac3a9c5ef85e1d92656c8c45"
  end

  depends_on "cmake" => :build

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
