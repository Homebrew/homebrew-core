class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://github.com/wez/atomicparsley"
  url "https://github.com/wez/atomicparsley/archive/20210114.184825.1dbe1be.tar.gz"
  version "20210114.184825.1dbe1be"
  sha256 "8877262c86d0ad231a5b0eaa8ab9c0c1d4e06fafea0b96a819d9a5e565a28b8c"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/wez/atomicparsley.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "10ed6bfad101b5e57fd8d44e9485033308b56d09b4cc08bcd02d9b0eb45c7595" => :big_sur
    sha256 "5b27fb350ad43a09587dd8fb606b70b5c839c6b9a4079e054def9ffa58c3f69c" => :arm64_big_sur
    sha256 "164a92e2a72ac3f1e3a47edaad51114d83582019722d8688299684381299f5eb" => :catalina
    sha256 "04cdcb145d63be082b604db3b79284987c6fdc042b7b5451fd28b21789c015b4" => :mojave
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

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
