class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-6.0.0.tar.gz"
  sha256 "7b663e4db044b1fa4986bd018f827c18e96fe6d1f9a36732dcbb0450e7f518cb"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "adc88bc0093e025288c699f376e758089711a840792aea13c990fc379cee1ec8"
    sha256 cellar: :any,                 arm64_sonoma:  "20416d442a7595dce7526c6ad3cf61fadf9fd75378aac82c1895c7ec17e81deb"
    sha256 cellar: :any,                 arm64_ventura: "e00b6b7afc135ab8351c07cf4303540b4c533ca8ece84a4fe69acc13d87dae8f"
    sha256 cellar: :any,                 sonoma:        "b6e072007fa6ef95194d50126986fcc614371e0b4d8724ca1ee5ef0ccd8596de"
    sha256 cellar: :any,                 ventura:       "d17b37ed52039a49fc79fd6fae1e79dbfe3b2603806e105d3d53626af40c7a82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddd98a7738b8cb9ff067db4103d93f96ee4c9517a800d41ee142ec6ee14084ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9172a9b37e0d769eeab8e2bb77f2933b9f893652dbd1e49f9bc94569af9aa370"
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
