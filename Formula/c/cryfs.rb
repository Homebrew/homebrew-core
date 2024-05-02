class Cryfs < Formula
  include Language::Python::Virtualenv

  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.11.4/cryfs-0.11.4.tar.gz"
  sha256 "6caca6276ce5aec40bf321fd0911b0af7bcffc44c3cb82ff5c5af944d6f75a45"
  license "LGPL-3.0"
  revision 4
  head "https://github.com/cryfs/cryfs.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f07c80be17ab85edbeae0601b5798cedc22ede95f961bce4658c232fd1265309"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "boost"
  depends_on "curl"
  depends_on "fmt"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "range-v3"
  depends_on "spdlog"

  fails_with gcc: "5"

  def install
    system "cmake", "-B", "build", "-S", ".", *std_cmake_args,
                    "-DBUILD_TESTING=off",
                    "-DCRYFS_UPDATE_CHECKS=OFF",
                    "-DDEPENDENCY_CONFIG=cmake-utils/DependenciesFromLocalSystem.cmake"
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
