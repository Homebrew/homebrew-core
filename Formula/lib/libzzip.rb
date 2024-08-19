class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/refs/tags/v0.13.78.tar.gz"
  sha256 "feaeee7c34f18aa27bd3da643cc6a47d04d2c41753a59369d09102d79b9b0a31"
  license any_of: ["LGPL-2.0-or-later", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dfe584a561bf184555dd1cb0f5fce07d900a466444cdde7d968e756abcd03c79"
    sha256 cellar: :any,                 arm64_ventura:  "830a5c48de37071f87aabff06fef3bbd19e9ffacb06a550621eb3ec38858f730"
    sha256 cellar: :any,                 arm64_monterey: "59aed17c6a583e3a6d7b9d500c0eff2cd79e6f9c8c8e7f9a96b55152b0a0b5ab"
    sha256 cellar: :any,                 sonoma:         "193c19913f3d8f32c917dc5bec67cb7d6b5faed07c9342f8d03f54d2eed23b90"
    sha256 cellar: :any,                 ventura:        "95b6daea1b5be5ca6101f342874d207aef6c8b8186970438cadb144f9c33564b"
    sha256 cellar: :any,                 monterey:       "b81fae11a942992eb933f8d9ee2391727363009ec9dbc5521b07546606031f5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e595cd977c07fdbde35b70ab99fd3f65f1f919c436d999506eb8117f875d0d99"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "zip" => :test
  uses_from_macos "zlib"

  def install
    args = %W[
      -DZZIPTEST=OFF
      -DZZIPSDL=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"README.txt").write("Hello World!")
    system "zip", "test.zip", "README.txt"
    assert_equal "Hello World!", shell_output("#{bin}/zzcat test/README.txt")
  end
end
