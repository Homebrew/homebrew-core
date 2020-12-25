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
    sha256 "b57bf9581b8c27586144ff53aa01dcb7954e930614466d15363982948cd03ff4" => :big_sur
    sha256 "2e3e79bdba5478eccfd88e338525f9d40e920c13fb33ce5aed9bc9c5ff3b07e4" => :arm64_big_sur
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
