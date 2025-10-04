class Lzfse < Formula
  desc "Apple LZFSE compression library and command-line tool"
  homepage "https://github.com/lzfse/lzfse"
  url "https://github.com/lzfse/lzfse/archive/refs/tags/lzfse-1.0.tar.gz"
  sha256 "cf85f373f09e9177c0b21dbfbb427efaedc02d035d2aade65eb58a3cbf9ad267"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "712821a6da6f0a4e597c597b3df2c804135d1f870ad4ffc9eb4e9b039aeac71c"
    sha256 cellar: :any,                 arm64_sequoia:  "4ece33c62d9b2e19ea17089e85b380c3e124413d45fab40e307231c6defec609"
    sha256 cellar: :any,                 arm64_sonoma:   "a10f2fce7192b49ddf9b0c34370dfd50d2a12264104342f36c731a9d6a69941b"
    sha256 cellar: :any,                 arm64_ventura:  "e6932c59d8f1f9462445d06f243af20c1c2a09c6eaaea3c5cc4ec8efb9466ce1"
    sha256 cellar: :any,                 arm64_monterey: "33351619d36c622d4fbd63cd02f475e4f88da26a46351f62466003536f417cb4"
    sha256 cellar: :any,                 arm64_big_sur:  "99a83dce436e46d4d13a9825155abec9105857b23037a555bc399728c925d5c7"
    sha256 cellar: :any,                 sonoma:         "8a0c25ee34291e5de716920b58d6b25846edbea682b3434ffecc406d667a3ce3"
    sha256 cellar: :any,                 ventura:        "907f55be17f387f646e1bf8e95b60cd64534ea8b39210bcdf29aa9fcde331a61"
    sha256 cellar: :any,                 monterey:       "11e09e89227d27ecba48954e45077fcc0d0b4c5f6e55e8540be252ffb3050770"
    sha256 cellar: :any,                 big_sur:        "77feda1fad9da3e2e867fb1a7ca2c56b9beb300cf9d5fa6c383c516f4613c34e"
    sha256 cellar: :any,                 catalina:       "bf5a9fba1911206046cb4698e9b23ac23f247bcd1c47cdd779fa7a786c40aa27"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5ed34f88c34b8be3427102200be747817b78462cc251f02bd29b5cc3df6180d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13f5733f570ee2f8d436c66beed32cbece59522b57653fba497c9dda82bd0aed"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"original").write Random.new.bytes(0xFFFF)

    system bin/"lzfse", "-encode", "-i", "original", "-o", "encoded"
    system bin/"lzfse", "-decode", "-i", "encoded", "-o", "decoded"

    assert_equal (testpath/"original").read, (testpath/"decoded").read
  end
end
