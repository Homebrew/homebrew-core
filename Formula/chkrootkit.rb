class Chkrootkit < Formula
  desc "Rootkit detector"
  homepage "http://www.chkrootkit.org/"
  url "ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit-0.52.tar.gz"
  mirror "https://fossies.org/linux/misc/chkrootkit-0.52.tar.gz"
  sha256 "c578c0b9c8ae0729c2de7075f896f3d168e768c52e319a7706c9a7e46ff7a211"

  bottle do
    cellar :any_skip_relocation
    sha256 "2563d001fbe410534061a3d3d0476dea7ecb5da2d54828badaee6e547c680d94" => :mojave
    sha256 "97e158e6ce44a0f9a96b7cdaf827446632f1c74a51068417b6588dd80c15116d" => :high_sierra
    sha256 "2ddd7a341ced3bdfd2a622e48e19627fccaeaff174c7241c42cc0e3305557a16" => :sierra
    sha256 "18d66e7ae08f00fef387e72c8f8f9f74042f32247e52adabf5b838c4ffc83d58" => :el_capitan
    sha256 "889be3584a64397ade2ccf4bf373a1e9c85b73880d209f6e10d7e19eecc122e7" => :yosemite
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
