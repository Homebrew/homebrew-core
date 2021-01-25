class Chkrootkit < Formula
  desc "Rootkit detector"
  homepage "http://www.chkrootkit.org/"
  url "ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit-0.54.tar.gz"
  mirror "https://fossies.org/linux/misc/chkrootkit-0.54.tar.gz"
  sha256 "154c926921f53db60728a7cbc97ca88658b694c14b7d288efe383e0849915607"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?download[^>]*>chkrootkit v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "63febac78a6eceecb7b3875b05810363448ddb25aa781b0d3ee30f32068696b9" => :big_sur
    sha256 "63b5d12ee1f886330021355cf5e735d35a41614f1b90ce417b59168763479034" => :arm64_big_sur
    sha256 "db64fdae3055ce77b6771ef8b67362d68c11ef099373b71490204b135e4d84c3" => :catalina
    sha256 "6eb199dd0a6e307e5dc8ead5bc7b4981ac8697ebb3e8bd1ec3c34390b1cbcbd5" => :mojave
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}",
                   "STATIC=", "sense", "all"

    bin.install Dir[buildpath/"*"].select { |f| File.executable? f }
    doc.install %w[README README.chklastlog README.chkwtmp]
  end

  test do
    assert_equal "chkrootkit version #{version}",
                 shell_output("#{bin}/chkrootkit -V 2>&1", 1).strip
  end
end
