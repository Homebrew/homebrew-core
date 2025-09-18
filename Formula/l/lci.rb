class Lci < Formula
  desc "Interpreter for the lambda calculus"
  homepage "https://www.chatzi.org/lci/"
  url "https://github.com/chatziko/lci/releases/download/v1.1/lci-v1.1.tar.gz"
  sha256 "51725e33a7066100757b7da84b2290a651a5f47b985eb3e3647acd871964cd58"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "8489fde41d750512814a3aa95a72fe1df512d724e9d543b7c05a0f515a0b8007"
    sha256                               arm64_sequoia: "13a9869c2bc147eb19005e15ed2ccd27a6afec14b8ec661b535e6a8a288b47bc"
    sha256                               arm64_sonoma:  "46ba0405d0111869ea90bd1fd0148807a65bda00be35589b8d67701b57ffcbf4"
    sha256                               arm64_ventura: "2cfa4820068d0e4495d3cf8bad083fb4a4fc5ba8b9e141f86fee1887b24bc38c"
    sha256                               sonoma:        "e32fad6844ab4a93730432d96c263980089464b7f382bf485903b79352d3538b"
    sha256                               ventura:       "0821036d4af1bfc500f333725f6caf28c1d2fc75a212d66131658f63ffdcd8fe"
    sha256                               arm64_linux:   "2d8de81c217d9624bbbdb63f6375d685cd43d08ddcc299fe2ff9a8143ea345d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19652d5516ba04ec5519854bdfb56b38156890fa066d6ced1a8d6d228e60c509"
  end

  depends_on "cmake" => :build

  conflicts_with "lolcode", because: "both install `lci` binaries"

  def install
    # Workaround for CMake 4 compatibility
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "[I, 2]", pipe_output(bin/"lci", "Append [1] [2]\n")
  end
end
