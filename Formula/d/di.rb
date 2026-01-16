class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-6.2.1.tar.gz"
  sha256 "4003e359fa6baad4494118e91ae561e5475b7125001298f6b5552f5666c274a6"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30470c054214fd8911d5d67ae2b54f5355513dae7e1eea9cd831a63ee6f98d88"
    sha256 cellar: :any,                 arm64_sequoia: "de867425bd6cce80299dbd1eee1560a59031a49da18c57cdc046426f8665d683"
    sha256 cellar: :any,                 arm64_sonoma:  "917e4a7f601445b7d810ca00c4c489b70823ba7a04eeab3a3cf0da5c7cb01605"
    sha256 cellar: :any,                 sonoma:        "941bb964945284a2de8f4149e5a91b6577ad166244353118627570c160ebda4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cf6b30585cc48fe7f80c4a393fe9f9d6dc9474699f61abb67a12e6c06a9e7ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52778b2dc20e0488ee439520f56aaf414abdf9a67016b86a3519d0e3bbe41c06"
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
