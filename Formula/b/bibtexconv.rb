class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.0.3.tar.gz"
  sha256 "aa1b001cc74d7690b7f4a3cf166f0935a0d8215c01aa6dd078aaec53fb87939d"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a6ea8db2a031b9a3b011af0163bccbc727f710d26f72cf7e51e34324fac2b585"
    sha256 cellar: :any,                 arm64_sonoma:  "e6c62a54f939845c2329216c42e7030fcfcac2562885e223e38e10c2eab8fb75"
    sha256 cellar: :any,                 arm64_ventura: "28d2d4de8511c1493cdbecf96877a717adb6f6ff2821227779fc5d844ef823bb"
    sha256 cellar: :any,                 sonoma:        "debf16aa133776fab8b368b24ca57e08f463dc2442dec8ab64be1c0d1d71d376"
    sha256 cellar: :any,                 ventura:       "66230d76b581cde929ef6a9a05c3e42304e3068518930fc7ca561201452b4408"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77805012a4bab29ae2c7046e4338e260f1dc9fe0e38d378af6c42e630bd751c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d8e561bb0cfa39a9542d8e36136aa69db4e05615b0333fa8b972931248c9d24"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@3"].opt_lib}/#{shared_library("libcrypto")}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", "#{testpath}/ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end
