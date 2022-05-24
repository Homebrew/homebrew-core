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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05f8a9426c513b0bcd3e6bd3bdb2884bb85c212b9eb3cbb098d6d5e5ec0f7920"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1997965e9c425cd6b4d524f79ccae01c052554f1cf3926dd24ea86c50c8f494"
    sha256 cellar: :any_skip_relocation, monterey:       "5144666ed89e97f8a79eb646d3d6151a790f4edbfcf924204073e3b495e5f05f"
    sha256 cellar: :any_skip_relocation, big_sur:        "59476f055d9aba2d3d803830a7b6045313d39fb40a852932dd54191efc337672"
    sha256 cellar: :any_skip_relocation, catalina:       "99e290df24ad259c91959669143108187f4654694bca9d857673e23dbd85997a"
    sha256 cellar: :any_skip_relocation, mojave:         "e2d278c0505712c61e651450dc43c12fc2b62d0f37b018ff30031f91d4f33b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "872001ac408f9eaca26e329c3895162fc65f623e56c7b9b1b5802055748b34aa"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" => :build
  end

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
