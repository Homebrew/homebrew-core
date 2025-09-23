class Cryfs < Formula
  include Language::Python::Virtualenv

  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/1.0.1/cryfs-1.0.1.tar.gz"
  sha256 "5383cd77c4ef606bb44568e9130c35a996f1075ee1bdfb68471ab8bc8229e711"
  license "LGPL-3.0-or-later"
  revision 3
  head "https://github.com/cryfs/cryfs.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ddcf8608265ef9bb8f0016f35f1b1a730568c505f52eba68626cb40c1f5bd868"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e304a42cd9444d84ee6699bf11caa3dc31560c45bc70cfcfd19f661179d30814"
  end

  depends_on "cmake" => :build
  depends_on "curl" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "range-v3" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on "libfuse@2" # FUSE 3 issue: https://github.com/cryfs/cryfs/issues/419
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "spdlog"

  # Backport fix for Boost.Process 1.88.0+. Remove in the next release
  patch do
    url "https://github.com/cryfs/cryfs/commit/91e2c9b8fd5f7a1b0e57ad1310534606ce70c338.patch?full_index=1"
    sha256 "50551c3d73502a9e9796d95f751969e9865a03e6d7429123388ae1f52eb47131"
  end

  # Fix build with Boost 1.89.0, pr ref: https://github.com/cryfs/cryfs/pull/500
  patch do
    url "https://github.com/cryfs/cryfs/commit/f2f3c19979545c4789647e648cc1480ce647f42a.patch?full_index=1"
    sha256 "35491d35bb341c8651bac6c7348b4d8d42df19304a09824d0eb94206180231d6"
  end

  def install
    ENV.runtime_cpu_detection # for bundled cryptopp
    system "cmake", "-B", "build", "-S", ".", "-DCRYFS_UPDATE_CHECKS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CRYFS_FRONTEND"] = "noninteractive"

    # Test showing help page
    assert_match "CryFS", shell_output("#{bin}/cryfs 2>&1", 10)
    assert_match version.to_s, shell_output("#{bin}/cryfs --version")

    # Test mounting a filesystem. This command will ultimately fail because homebrew tests
    # don't have the required permissions to mount fuse filesystems, but before that
    # it should display "Mounting filesystem". If that doesn't happen, there's something
    # wrong. For example there was an ABI incompatibility issue between the crypto++ version
    # the cryfs bottle was compiled with and the crypto++ library installed by homebrew to.
    mkdir "basedir"
    mkdir "mountdir"
    expected_output = "fuse: device not found, try 'modprobe fuse' first"
    assert_match expected_output, pipe_output("#{bin}/cryfs -f basedir mountdir 2>&1", "password")
  end
end
