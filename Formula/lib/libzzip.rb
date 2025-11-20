class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/refs/tags/v0.13.80.tar.gz"
  sha256 "21f40d111c0f7a398cfee3b0a30b20c5d92124b08ea4290055fbfe7bdd53a22c"
  license any_of: ["LGPL-2.0-or-later", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a28095574cbba9c6d2edc7d5fccc78c9791a6f01f29a9292be6e19efe3a3f06f"
    sha256 cellar: :any,                 arm64_sequoia: "905b79b5f4c5e3af637334bf139c99ecbbc435b22cf4639be857c6357b86b32b"
    sha256 cellar: :any,                 arm64_sonoma:  "c29b7219f2335726ba15136a17a7d9936cdb94c0433e1d6d04f3c51ac2beaac4"
    sha256 cellar: :any,                 arm64_ventura: "21bac7dfa6d21512e6241c99669f3a18725ff0f6b1b5090a9986716a9194de7f"
    sha256 cellar: :any,                 sonoma:        "16ee772a074713966a5aa332d24b1a5461bcc53647c871be76d7c7bac5fde58f"
    sha256 cellar: :any,                 ventura:       "a358550b0270d3f538103da70c91a6f212d68904e4d9b0b4580788056ffd5d4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54238581bf4ae3a836c5b99d277a9df77396e1b417a3948d661bda8a91bd1731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81fc37d72b6f4c3cee94257491ce72ef3c63d6f4302428b5f08ffd1a1bb0a23e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "python" => :build
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
