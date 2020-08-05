class Prover9 < Formula
  desc "Automated theorem prover for first-order and equational logic"
  homepage "https://www.cs.unm.edu/~mccune/prover9/"
  url "https://www.cs.unm.edu/~mccune/prover9/download/LADR-2009-11A.tar.gz"
  version "2009-11A"
  sha256 "c32bed5807000c0b7161c276e50d9ca0af0cb248df2c1affb2f6fc02471b51d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f637c295f07ddf31eedf6bcc73b957584da4d55cb92c7bfea3264d6c3780d1b" => :catalina
    sha256 "5ae1f642fa781841fc843a548b5327cf1dfb8d8c4fbe5ea83ddffef004282d57" => :mojave
    sha256 "055cf6646dd19effa87d7b9fa8e820c24710a023bcefc98c35604205530ab2c3" => :high_sierra
  end

  def install
    ENV.deparallelize
    system "make", "all"
    bin.install "bin/prover9", "bin/mace4"
    man1.install Dir["manpages/*.1"]
  end

  test do
    (testpath/"x2.in").write <<~EOS
      formulas(sos).
        e * x = x.
        x' * x = e.
        (x * y) * z = x * (y * z).
        x * x = e.
      end_of_list.
      formulas(goals).
        x * y = y * x.
      end_of_list.
    EOS
    (testpath/"group2.in").write <<~EOS
      assign(iterate_up_to, 12).
      set(verbose).
      formulas(theory).
      all x all y all z ((x * y) * z = x * (y * z)).
      exists e ((all x (e * x = x)) &
                (all x exists y (y * x = e))).
      exists a exists b (a * b != b * a).
      end_of_list.
    EOS

    system bin/"prover9", "-f", testpath/"x2.in"
    system bin/"mace4", "-f", testpath/"group2.in"
  end
end
