class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v1.1.2.tar.gz"
  sha256 "cd23f389c5366584a5cf5679224da8811c17a6862282220abe28f7c91d3ed0cc"

  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b56d25e1844ad13f35464cacc27db4a885e3df4dddefe5ca20d579bd14fb91f" => :sierra
    sha256 "b6899315d289420c94305bbc60bf236d5b8a877e147645d51c1aebde3f9dec98" => :el_capitan
    sha256 "ad5d8d0d865f9d369090698432c822c7842a4b59d8c5bc1627cd54959cb3329c" => :yosemite
  end

  def install
    bin.mkpath
    inreplace "Makefile",
      "@echo $(INSTALL_PROGRAM) blueutil $(DESTDIR)$(bindir)/blueutil",
             "$(INSTALL_PROGRAM) blueutil #{bin}/blueutil"
    system "make", "install"
  end

  test do
    system "#{bin}/blueutil"
  end
end
