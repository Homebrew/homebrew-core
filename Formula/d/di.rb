class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-5.0.14.tar.gz"
  sha256 "1ffe5480c4fb09fcda0909c8b32b519c60b5715da617afd2431114d5d5432ad9"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "91831ff7608570f0a5141dad191b486cbc04cec4d7bab33985bd54efc9ceaa6c"
    sha256 cellar: :any,                 arm64_sonoma:  "8726a1ed9a995ac971746ca55d262c2065995437634dcf6ada3f6493606cad28"
    sha256 cellar: :any,                 arm64_ventura: "3f692eb3aa476923c70e027c1e9f818b5fa176427b3d6512a1c80d77027c9a35"
    sha256 cellar: :any,                 sonoma:        "d2f3c2547d4a5974d7fc1e26c1ee6f51b7a80b4d8a9a1bef1521c0918cba802f"
    sha256 cellar: :any,                 ventura:       "1bcff6cbde4672a362dd09ddc0b6a89523362654826c7de5c1558fb216d09ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59601143be97e367844626a8e5eddcbd0cd4b42a65f5015f7b50871aaffced44"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    args = %W[
      -DDI_BUILD=Release
      -DDI_VERSION=#{version}
      -DDI_LIBVERSION=#{version}
      -DDI_SOVERSION=#{version.major}
      -DDI_RELEASE_STATUS=production
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di --version")
    system bin/"di"
  end
end
