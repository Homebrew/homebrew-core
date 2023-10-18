class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/archive/v0.6.4.tar.gz"
  sha256 "1cbb1a79bfe6c37884a538b56504fa0975e78e492aee7c265a42f654c6056cb3"
  license "BSD-2-Clause"
  head "https://github.com/anrieff/libcpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 sonoma:       "bb30d48382c4ba6dc5e79a8fa5c228c057acf5daeefc9f15b890b1a611fd2fb6"
    sha256 cellar: :any,                 ventura:      "3fd2c58eee26b0618a2c0532c578f2aaa5cd18de1dd6ad1ee428ab749609593f"
    sha256 cellar: :any,                 monterey:     "cb4553f58f5e686ca065860190eea22fbd48ee5639b47dc8b8f224d52c876587"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1afb6f73541e7467b64880b7a73fe2e12168620eb2c69b8d5342a0a3e35aebc6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on arch: :x86_64

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"cpuid_tool"
    assert_predicate testpath/"raw.txt", :exist?
    assert_predicate testpath/"report.txt", :exist?
    assert_match "CPUID is present", File.read(testpath/"report.txt")
  end
end
