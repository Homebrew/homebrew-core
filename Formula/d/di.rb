class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-6.2.0.tar.gz"
  sha256 "65f7752988949c1186d368745ec1a2d9e1597cd8b20dee7d3cbed0da8ef4e4dc"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2414498a2d26d606fb96b9634a500511888ffb6980e3b69517eab6e1ebe54736"
    sha256 cellar: :any,                 arm64_sequoia: "36efa2668df142328f2c959f3a28997cf4c5f0f7eebbfb3f999c7aa89dd38125"
    sha256 cellar: :any,                 arm64_sonoma:  "df34deef425a45072a7effb3694944b42e7b92cfebcf997c8095c1fde6be6906"
    sha256 cellar: :any,                 sonoma:        "1306e557c1a1f5b3a8513f1cc60154138fbe7cd1677738ac228e6647cac8f84c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ce1c25c94175f2334981070a84b70e6be5d49441cbd264a18f3fcfe76fa11a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91c00ae615c5055f62145f8cc95e12f90e4b27913649c988467bc206d75263fb"
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
