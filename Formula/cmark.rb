class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/0.30.1.tar.gz"
  sha256 "9609506bd7473e769452488ef981eb53f082011b1ec6c9b6c73ed57062e25ee6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2a6421e2a5c12e65151d7ee68588825f4989e446c02a331178d9cf80da959cdb"
    sha256 cellar: :any,                 big_sur:       "e62c5f9e7b4e142d7fc333f74a37e9f7369edf99e3311f104921d55063dd46d9"
    sha256 cellar: :any,                 catalina:      "aad5f683d644f5a1197f735d7b3af3dc4764f8ad7e19c3de87974d3a80cf3645"
    sha256 cellar: :any,                 mojave:        "2c610141e4791ff7407b12065a492a058da98f9a4841ff65be6a998c603006e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eed3fa34bf57c9a862c4251dd5bfc59d51ce97bbab49c9faf25e60d1aaab266"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  conflicts_with "cmark-gfm", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark", "*hello, world*")
    assert_equal "<p><em>hello, world</em></p>", output.chomp
  end
end
