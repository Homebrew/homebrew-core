class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://github.com/wez/atomicparsley"
  url "https://github.com/wez/atomicparsley/archive/20221229.172126.d813aa6.tar.gz"
  version "20221229.172126.d813aa6"
  sha256 "2f095a251167dc771e8f4434abe4a9c7af7d8e13c718fb8439a0e0d97078899b"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/wez/atomicparsley.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b34175e14acdb01523b83fb7e84ba96cfedb6fba3e40e33a594481e5020608dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "996bb284186eaa30569575a32e0447e7e5cf2f0223c4367e58a76a1addfac27d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e553cc071ff479799cd114c085b56f03f23b904ae94d03c8cf490845dae9f7e"
    sha256 cellar: :any_skip_relocation, ventura:        "558289aeb9de98c1c813afab51c3c0d1d92fdf82388a805781d2f4b11df20690"
    sha256 cellar: :any_skip_relocation, monterey:       "8cc2e316a549c4d1bdc4041fd9a6cfa47673e3ed196b3aecba5e72492d2dc152"
    sha256 cellar: :any_skip_relocation, big_sur:        "256816a97ae5ff57bbf87c40db79601522aec0b6f0bf2a0b4dc939badbe730c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b7c684a13e7f448cf4fd791c7534f43489428ee0eae19749c129b4db1389d02"
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
