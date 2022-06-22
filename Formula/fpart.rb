class Fpart < Formula
  desc "Sorts file trees and packs them into bags"
  homepage "https://github.com/martymac/fpart/"
  url "https://github.com/martymac/fpart/archive/fpart-1.5.1.tar.gz"
  sha256 "c353a28f48e4c08f597304cb4ebb88b382f66b7fabfc8d0328ccbb0ceae9220c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2274c88d661ee015868ec449a32322bd195c1ce2b4afe1aafebdc02c5bd5399d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41e62a21932f2b1e376d4b1b639130e7448ce1706aa50822c5987b36e2a30754"
    sha256 cellar: :any_skip_relocation, monterey:       "6b5ce070c9290fb6bfd86dbef79e2d541a052d601ab0c69577830eb94fb83c80"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab79762617a69826fde9d40188b62fd9243c61c45234ae7ad8c879d34bf3c58c"
    sha256 cellar: :any_skip_relocation, catalina:       "66ce10f074e12713d97d95e73c49c16f1f99597e7ab21728c4dbed791c276f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98d9ad2199a9257d6c6cbc8dea2a7105df0c2b5e7e306d94e9f1be787a274f3"
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
