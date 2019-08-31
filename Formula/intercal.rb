class Intercal < Formula
  desc "Esoteric, parody programming language"
  homepage "http://catb.org/~esr/intercal/"
  url "http://catb.org/~esr/intercal/intercal-0.31.tar.gz"
  sha256 "93d842b81ecdc82b352beb463fbf688749b0c04445388a999667e1958bba4ffc"

  bottle do
    sha256 "b37df8dcb2c144fdef576b22097930cd70bfbc293df70d37523ad5d2714e80bc" => :mojave
    sha256 "cf859045ee10ad86e4d430e86224f5d08e2cac391a39b7f7bab62ef336a59d65" => :high_sierra
    sha256 "0af682680ed91e303158222255b56bac5c20f46882b90d0e54e500e93f461119" => :sierra
    sha256 "aedc619191db840cebc64a0c96c7165c4f48e1af44849e4422f1839a6e7cc311" => :el_capitan
    sha256 "889ab74f3c682bb55558d244781899c730eecb894cfad58083202d0674d46742" => :yosemite
  end

  head do
    url "https://gitlab.com/esr/intercal.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    if build.head?
      cd "buildaux" do
        system "./regenerate-build-system.sh"
      end
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    (etc/"intercal").install Dir["etc/*"]
    pkgshare.install "pit"
  end

  test do
    (testpath/"lib").mkpath
    (testpath/"test").mkpath
    cp pkgshare/"pit/beer.i", "test"
    cd "test" do
      system bin/"ick", "beer.i"
      system "./beer"
    end
  end
end
