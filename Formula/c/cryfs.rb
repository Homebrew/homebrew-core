class Cryfs < Formula
  include Language::Python::Virtualenv

  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/1.0.3/cryfs-1.0.3.tar.gz"
  sha256 "5550f612f7b692e60c0c10a0331dcefbcc9616ad1411a016de7e4503ad866696"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://github.com/cryfs/cryfs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "aad3465262b4d592cf14d87253fca6f7543c8f1f1b6a5ab177d36befda519fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4d391a757720609a5f34600e573d517e8f061afddb31ff743d4f18737e2cf399"
  end

  depends_on "cmake" => :build
  depends_on "curl" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "range-v3" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on "libfuse@2" # FUSE 3 issue: https://github.com/cryfs/cryfs/issues/419
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "spdlog"

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
