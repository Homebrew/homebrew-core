class Clasp < Formula
  desc "Answer set solver for (extended) normal logic programs"
  homepage "http://potassco.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/potassco/clasp/3.2.0/clasp-3.2.0-source.tar.gz"
  sha256 "eafb050408b586d561cd828aec331b4d3b92ea7a26d249a02c4f39b1675f4e68"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd9ad8525cfbb0692dd94cedbd76849edbc222fae644b27fe1e106679e39c64d" => :sierra
    sha256 "66882d87c5b4aead5af374d54438cbac8877c493e0aaf56798e8c629581d7186" => :el_capitan
    sha256 "a7770d88cfb59b6678f297ceaa8a38e305eb11a28df6a887205a36c90728c973" => :yosemite
  end

  option "with-mt", "Enable multi-thread support"

  depends_on "tbb" if build.with? "mt"

  def install
    if build.with? "mt"
      ENV["TBB30_INSTALL_DIR"] = Formula["tbb"].opt_prefix
      build_dir = "build/release_mt"
    else
      build_dir = "build/release"
    end

    args = %W[
      --config=release
      --prefix=#{prefix}
    ]
    args << "--with-mt" if build.with? "mt"

    bin.mkpath
    system "./configure.sh", *args
    system "make", "-C", build_dir, "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/clasp --version")
  end
end
