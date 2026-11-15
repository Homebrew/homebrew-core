class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "https://freewareadvancedaudio.github.io"
  url "https://github.com/FreewareAdvancedAudio/faad2/archive/refs/tags/2.11.4.tar.gz"
  sha256 "ee479ccbae4a8387ab696e6f21a481bd83fe3881471cafa81b4ae59d7d3aed43"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "15d889dc25b77a061642b62d94aafae9989197babc254580666e400ce25fb485"
    sha256 cellar: :any, arm64_tahoe:       "a1c6012d8a4d604d30f684d72ccf39c5c0aab2c724a4868f2cc143f52fed0dfc"
    sha256 cellar: :any, arm64_sequoia:     "b9875c841217859d9c92d675b4cf719d53145cbafee9bac95273713822f55281"
    sha256 cellar: :any, arm64_linux:       "ddf1e8094dd399ed3bd3e5c779005185b9d02fd43a27f574f156f60d8d243d69"
    sha256 cellar: :any, x86_64_linux:      "74bee1119ba9061e934ac3b2d3963993658f6ea775676545ca0997022ed7ee24"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/faad -i #{test_fixtures("test.m4a")} 2>&1")
    assert_match "LC AAC\t0.192 secs, 1 ch, 8000 Hz", output
  end
end
