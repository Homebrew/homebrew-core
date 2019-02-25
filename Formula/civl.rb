class Civl < Formula
  desc "The Concurrency Intermediate Verification Language"
  homepage "https://vsl.cis.udel.edu/civl/"
  url "https://vsl.cis.udel.edu/lib/sw/civl/1.19/r5139/release/CIVL-1.19_5139.tgz"
  version "1.19-5139"
  sha256 "1a372b68710af202daaf7bdeb2441ece3c87bc905cae0ed57f5c0585105cbb3e"

  bottle :unneeded

  depends_on :java => "1.8+"
  depends_on "z3"

  def install
    libexec.install "lib/civl-1.19_5139.jar"
    bin.write_jar_script libexec/"civl-1.19_5139.jar", "civl"
    pkgshare.install "doc", "emacs", "examples", "licenses"
  end

  test do
    # Test with example suggested in manual.
    example = pkgshare/"examples/concurrency/locksBad.cvl"
    assert_match "The program MAY NOT be correct.",
                 shell_output("#{bin}/civl verify #{example}")
    assert_predicate testpath/"CIVLREP/locksBad_log.txt", :exist?
  end
end
