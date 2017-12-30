class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.3.4.tar.gz"
  sha256 "640ae4d808ca69a97e046ff568999981ca196e13171cb08a4ce666a1d078f278"

  bottle do
    sha256 "fa4f67c2361205d54698e9a87f2a586d95ae8c34aa50c98bb72c3d522903333f" => :high_sierra
    sha256 "b57f2ec643d75111a7f1078d656e376e24bd871fe04ca32fa63cfb2b292bdacd" => :sierra
    sha256 "8455b5498446476972e353ca55b31e8acbd141c696cc8562edcc16a0d4235584" => :el_capitan
  end

  depends_on "tbb"

  def install
    tbb = Formula["tbb"]
    system "make", "install", "WITH_TBB=1", "prefix=#{prefix}",
           "EXTRA_FLAGS=-L #{tbb.opt_lib}", "INC=-I #{tbb.opt_include}"

    pkgshare.install "example", "scripts"
  end

  test do
    system "#{bin}/bowtie2-build",
           "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert_predicate testpath/"lambda_virus.1.bt2", :exist?,
                     "Failed to create viral alignment lambda_virus.1.bt2"
  end
end
