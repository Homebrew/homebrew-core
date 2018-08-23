class Bookloupe < Formula
  desc "List common formatting errors in a Project Gutenberg candidate file"
  homepage "http://www.juiblex.co.uk/pgdp/bookloupe/"
  url "http://www.juiblex.co.uk/pgdp/bookloupe/bookloupe-2.0.tar.gz"
  sha256 "15b1f5a0fa01e7c0a0752c282f8a354d3dc9edbefc677e6e42044771d5abe3c9"

  bottle do
    cellar :any
    sha256 "a0a98b728bad89aa1e75a6a6ac3cd359a8d619ba0903db6acff8dc111fb51593" => :mojave
    sha256 "4fe58e56ba2306c1edd1d8d9c6cc73c8b8be1a2a9c90cb077c2d19a695af03c0" => :high_sierra
    sha256 "8f914d9f48856a9de6e24aaa1fc392f9b99f18fcd49a2688d5dae3272772a96b" => :sierra
    sha256 "78a85f95ef2f53a4c6fdba498ab703d8e41273842df43e23b6a8d0d5e043ceed" => :el_capitan
    sha256 "787513fe860f0c5afd7d7705a10a4f2604a1210e2898f9eff3c46897c7fbefa1" => :yosemite
    sha256 "a696f92c2cf476cdb6f89d01c3f962dbdd52c48ae8b04f0b34cd4de21f6957eb" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["BOOKLOUPE"] = "#{bin}/bookloupe"

    Dir["#{pkgshare}/*.tst"].each do |test_file|
      # Skip test that fails on macOS
      # http://project.juiblex.co.uk/bugzilla/show_bug.cgi?id=39
      # (bugzilla page is not publicly accessible)
      next if test_file.end_with?("/markup.tst")

      system "#{bin}/loupe-test", test_file
    end
  end
end
