class Intercal < Formula
  desc "Esoteric, parody programming language"
  homepage "http://catb.org/~esr/intercal/"
  url "http://catb.org/~esr/intercal/intercal-0.31.tar.gz"
  sha256 "93d842b81ecdc82b352beb463fbf688749b0c04445388a999667e1958bba4ffc"

  bottle do
    sha256 "d048d5c58fd1fc3b17c44103b3bbddd445a657415c215916587d9eb8e7f9c2da" => :mojave
    sha256 "c0569e08915adc912bdc3fb149d0d3c50e7a2d941fff8b2d951b22fcfaf4539f" => :high_sierra
    sha256 "b00c959878aaead39f9106ef199d7082b4e1a62ef6957f11796a99650678c9b2" => :sierra
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
