class Civl < Formula
  desc "The Concurrency Intermediate Verification Language"
  homepage "https://vsl.cis.udel.edu/civl/"
  url "https://vsl.cis.udel.edu/lib/sw/civl/1.7/r3157/release/CIVL-1.7_3157.tgz"
  version "1.7-3157"
  sha256 "49ed0467ea281bf5a436b2caf4f87862d3f613fa9e6e746ce52cfd409c3f4403"
  revision 1

  bottle :unneeded

  depends_on :java => "1.8+"
  depends_on "z3"

  def install
    libexec.install "lib/civl-1.7_3157.jar"
    bin.write_jar_script libexec/"civl-1.7_3157.jar", "civl"
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
