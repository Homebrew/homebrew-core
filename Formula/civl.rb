class Civl < Formula
  desc "The Concurrency Intermediate Verification Language"
  homepage "https://vsl.cis.udel.edu/civl/"
  url "https://vsl.cis.udel.edu/lib/sw/civl/1.20/r5259/release/CIVL-1.20_5259.tgz"
  version "1.20-5259"
  sha256 "15bf63b3a92300e8432e95397284e29aaa5897e405db9fc2d56cd086f9e330d3"
  revision 1

  bottle :unneeded

  depends_on "openjdk"
  depends_on "z3"

  def install
    underscored_version = version.to_s.tr("-", "_")
    libexec.install "lib/civl-#{underscored_version}.jar"
    bin.write_jar_script libexec/"civl-#{underscored_version}.jar", "civl"
    pkgshare.install "doc", "emacs", "examples", "licenses"
  end

  test do
    (testpath/".sarl").write <<~EOS
      prover {
        aliases = z3;
        kind = Z3;
        version = "#{Formula["z3"].version} - 64 bit";
        path = "#{Formula["z3"].opt_bin}/z3";
        timeout = 10.0;
        showQueries = false;
        showInconclusives = false;
        showErrors = true;
      }
    EOS
    # Test with example suggested in manual.
    example = pkgshare/"examples/concurrency/locksBad.cvl"
    assert_match "The program MAY NOT be correct.",
                 shell_output("#{bin}/civl verify #{example}")
    assert_predicate testpath/"CIVLREP/locksBad_log.txt", :exist?
  end
end
