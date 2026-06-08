class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-6.2.2.2.tar.gz"
  sha256 "19eeeb7ebcad3061ae7814cdae5593accfb2bb261ce24795a604a282cbfc60fe"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62d724a0e3eb3478b48eb8d94c7ba89f3b72e4675f75d523177e7a18a6b37516"
    sha256 cellar: :any,                 arm64_sequoia: "b0f9ecb8b5537a0b5ab09b4b8cf6dedd3001113f48c220873d9ff4331fe59ce5"
    sha256 cellar: :any,                 arm64_sonoma:  "56bb403fea87acd0e51c543d2d68c5ce7188abe0c5f9f3a571518d797a7ce7e0"
    sha256 cellar: :any,                 sonoma:        "004ef54b06af5aaedd8a6884719e64ce765d565e42fa012fda3408d1af69d3fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a5589a65efc777ac948a4c538bdd867516b9f173cebb3701fc8cd80526c1a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57ad47925b5cb2b800c1c540469598c1fde34be1aa3de30790292999af5fb8e1"
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
