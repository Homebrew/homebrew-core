class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://github.com/wez/atomicparsley"
  url "https://github.com/wez/atomicparsley/archive/20210124.204813.840499f.tar.gz"
  version "20210124.204813.840499f"
  sha256 "21e6eb6791b63ba1d06c6ffa9cf40ee81cec80da944e8a29c6dbd11d9de50b28"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/wez/atomicparsley.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d29de64c9e04de41b6bf897d6ad8e578c0ed19e555604089ba144b9695c2f6e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "470db93186b6c976ca728327ea33934436953150b57f63ac906c8dd20b6b41f5"
    sha256 cellar: :any_skip_relocation, catalina:      "55ac0fe11e2d88b0a4f1168e31b303c7da596504ce81c22cc9c734666cf50a9e"
    sha256 cellar: :any_skip_relocation, mojave:        "6636633b195ddb728a805a00dff40e99691857dc41e89ada45fc8506b4ecaa29"
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
