class Civl < Formula
  desc "The Concurrency Intermediate Verification Language"
  homepage "http://vsl.cis.udel.edu/civl/"
  url "http://vsl.cis.udel.edu/lib/sw/civl/1.7/r3157/release/CIVL-1.7_3157.tgz"
  version "1.7-3157"
  sha256 "33fa5b4877fbf494b0a4b426c15d6a165fa3db48a9f97cbf391818d965d2dfb9"
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
    # Civl needs to write configuration files to the user's home directory, but
    # Java has its own logic for determining that path.
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{testpath}"

    # Test with example suggested in manual.
    example = pkgshare/"examples/concurrency/locksBad.cvl"
    assert_match "The program MAY NOT be correct.",
                 shell_output("#{bin}/civl verify #{example}")
    assert File.exist?("CIVLREP/locksBad_log.txt")
  end
end
