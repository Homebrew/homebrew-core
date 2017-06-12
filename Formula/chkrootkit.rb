class Chkrootkit < Formula
  desc "Rootkit detector"
  homepage "http://www.chkrootkit.org/"
  url "ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit-0.52.tar.gz"
  mirror "https://fossies.org/linux/misc/chkrootkit-0.52.tar.gz"
  sha256 "c578c0b9c8ae0729c2de7075f896f3d168e768c52e319a7706c9a7e46ff7a211"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe08ca7c95b7153659a55de068d320103719eca8d7672bae9af1542c88af5046" => :sierra
    sha256 "d2092429968f96cff683f76ca3c302e1d55a01c0d63d44fcfefd31bd077f939d" => :el_capitan
    sha256 "bb5b75999c36b2323e0348b161bfe0d4891d9f09782367aa8b8eaf345f04de26" => :yosemite
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
