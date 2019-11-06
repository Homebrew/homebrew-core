class Chkrootkit < Formula
  desc "Rootkit detector"
  homepage "http://www.chkrootkit.org/"
  url "ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit-0.53.tar.gz"
  mirror "https://fossies.org/linux/misc/chkrootkit-0.53.tar.gz"
  sha256 "7262dae33b338976828b5d156b70d159e0043c0db43ada8dee66c97387cf45b5"

  bottle do
    cellar :any_skip_relocation
    sha256 "23a9f903721d19c0b6201163cb937823970c66592f094c673b1de1036da8bef9" => :catalina
    sha256 "286de88eef77a53b9c7fab85ef3cec8b9876cf49a48910cbb591e44c9ca5d631" => :mojave
    sha256 "55ab9957505513fd81d670c54e5ad1834fb72ae9cda7bd7cbc63f98feeccf24a" => :high_sierra
    sha256 "f16966e93433cb877b04be8ea086c8a23905290643099229ffa3d665b2d11994" => :sierra
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
