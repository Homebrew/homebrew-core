class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "cfd9e6bcda5da3f602273e55f983bdd747cb93dde0b9ec06560e074939314210"
  license "BSD-2-Clause"
  head "https://github.com/anrieff/libcpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 sonoma:       "cdf5030cd5af1bb803485b2853ac70667962e9df464a0be7efd10894c9f3ecf1"
    sha256 cellar: :any,                 ventura:      "84cba38211a65ec58b209c1616efd38e1053f2554dd3b629a9570dfb4a7caf14"
    sha256 cellar: :any,                 monterey:     "4e5d099b1a7a93f4b7748adfcca7d43369b22ee4bbe6fda5fae001794aa32472"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "12735bcc406da1a4362c7f366bdb098f2b4a63cd63cd0df11116a55692dd9a1d"
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
