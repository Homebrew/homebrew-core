class Civl < Formula
  desc "Concurrency Intermediate Verification Language"
  homepage "https://vsl.cis.udel.edu/civl/"
  url "https://vsl.cis.udel.edu/lib/sw/civl/1.22/r5854/release/CIVL-1.22_5854.tgz"
  version "1.22-5854"
  sha256 "daf5c5a7295909d45a26d8775a8e7677495d69ab9c303638394ec189c4956b0e"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://vsl.cis.udel.edu/lib/sw/civl/current/latest/release/"
    regex(/href=.*?CIVL[._-]v?(\d+(?:[._-]\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_", "-") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "71c991aa3a7b29a8c41578d2220e02bbaad9b42d000b3119a0f054bd57892f82"
  end

  depends_on "openjdk"
  depends_on "z3"

  def install
    underscored_version = version.to_s.tr("-", "_")
    libexec.install "lib/civl-#{underscored_version}.jar"
    bin.write_jar_script libexec/"civl-#{underscored_version}.jar", "civl"
    pkgshare.install "doc", "emacs", "licenses"
    (pkgshare/"examples/concurrency/").install "examples/concurrency/locksBad.cvl"
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
    assert_path_exists testpath/"CIVLREP/locksBad_log.txt"
  end
end
