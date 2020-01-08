class Irrtoolset < Formula
  desc "Tools to work with Internet routing policies"
  homepage "https://github.com/irrtoolset/irrtoolset"
  url "https://ftp.isc.org/isc/IRRToolSet/IRRToolSet-5.0.1/irrtoolset-5.0.1.tar.gz"
  sha256 "c044e4e009bf82db84f6a4f4d5ad563b07357f2d0e9f0bbaaf867e9b33fa5e80"

  bottle do
    cellar :any_skip_relocation
    sha256 "34751f8b110d9c4bf2358cf537f47aa775969cf125e4d5db28633eaa4f25e3f5" => :catalina
    sha256 "762255e42d2e0241eaf12e4367b7212657ff097f58fbd2cb80d599cb6489c58c" => :mojave
    sha256 "d80526a2be3e45463d775c12d4e53a4d16bee7d6b153f13df679c4b02c291dcc" => :high_sierra
    sha256 "c3bdb3567581aff255053d8ee218f3715e94cb05555456406982186a1bcffda0" => :sierra
    sha256 "3ab236e3d5041ddc54bf932d23f0a4da30d6dd876cb6ad4ec61a9b570c910779" => :el_capitan
    sha256 "2ce9b4ff7b1604e05d771e70f457394e1e6c642df4b456e38ba11be50f7a9cdc" => :yosemite
    sha256 "87576959ef0948ec184322a4d6756e62ca6e4695fd708c773317fce8570b2dcf" => :mavericks
  end

  head do
    url "https://github.com/irrtoolset/irrtoolset.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    if build.head?
      system "glibtoolize"
      system "autoreconf", "-i"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/peval", "ANY"
  end
end
