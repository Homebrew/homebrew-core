class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://github.com/wez/atomicparsley"
  url "https://github.com/wez/atomicparsley/archive/20210715.151551.e7ad03a.tar.gz"
  version "20210715.151551.e7ad03a"
  sha256 "546dcb5f3b625aff4f6bf22d27a0a636d15854fd729402a6933d31f3d0417e0d"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/wez/atomicparsley.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e262f2feabbc9f16383b5d83e66c28578331e2cf7548046c4af8227dec1a8f93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd6740f15d9d909a464b2759676bc5c8f9e7e0d47206637b136b398e2f71e4ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79353541a9980e951bdf0a3137105f14c3bb42bcb399e0a98ee5b814374cdbd5"
    sha256 cellar: :any_skip_relocation, ventura:        "38836330fb6f518aad718835a9277e1fe2eefc5825d3a26b4e89d4cb53815242"
    sha256 cellar: :any_skip_relocation, monterey:       "1813634f5288568fa89a502960bf9560f79f8d4c344f36d3c45b6cb322bf01bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "85983e4b886164a9e7d865ad629cbef1583bd171e7d2190634dc9968e23117e1"
    sha256 cellar: :any_skip_relocation, catalina:       "82b715beaadc88b8c342de0f71f1a81d24307cf2ec3a633c82db32f4ec11d2bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ffd502f75ccdee2e85002c006956f47dfb385ea5cb4709d79c1042baa4ee27b"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", ".", "--config", "Release"
    bin.install "AtomicParsley"
  end

  test do
    cp test_fixtures("test.m4a"), testpath/"file.m4a"
    system "#{bin}/AtomicParsley", testpath/"file.m4a", "--artist", "Homebrew", "--overWrite"
    output = shell_output("#{bin}/AtomicParsley file.m4a --textdata")
    assert_match "Homebrew", output
  end
end
