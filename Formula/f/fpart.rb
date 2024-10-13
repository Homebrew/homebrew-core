class Fpart < Formula
  desc "Sorts file trees and packs them into bags"
  homepage "https://github.com/martymac/fpart/"
  url "https://github.com/martymac/fpart/archive/refs/tags/fpart-1.6.0.tar.gz"
  sha256 "ed1fac2853fc421071b72e4c5d8455a231bc30e50034db14af8b0485ece6e097"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f3c6fd66bf8bf96441ddef5e3f98ec351bb5bcb312512b4d8ed950df9b5a21f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe4bb7a3f413343e8fcf6e5e4a927dd6db59d3407a859e0f4b5c502169bf4929"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1eb3a0ed3bb14417b1b60b8bcebb7152a9c6ba576d283ed49f02208c38d3d05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3fd142063bdd4a208b352b31a84d6c030ce1712598881a2d6d4d9f99173ca7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae588ec11f3e50b9ccf6ade1a8255509f0f58f28fced52e9d9b3ee58eb7f78c7"
    sha256 cellar: :any_skip_relocation, ventura:        "88ff0749453b933bc4a686315854c38c5fee050a31dd05b51478fefbb39de56a"
    sha256 cellar: :any_skip_relocation, monterey:       "24ebeb0b36685fc64cdfcb7e46e6eace244926e926334ba9aa470ee2f525a934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8180ca9e18c7ee57c59a4d612ecd3eb5c85820a3cc9e5f429ab48118f5913854"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"myfile1").write("")
    (testpath/"myfile2").write("")
    system bin/"fpart", "-n", "2", "-o", (testpath/"mypart"), (testpath/"myfile1"), (testpath/"myfile2")
    assert_predicate testpath/"mypart.1", :exist?
    assert_predicate testpath/"mypart.2", :exist?
    refute_predicate testpath/"mypart.0", :exist?
    refute_predicate testpath/"mypart.3", :exist?
  end
end
