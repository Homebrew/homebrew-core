class Mailcheck < Formula
  desc "Check multiple mailboxes/maildirs for mail"
  homepage "https://mailcheck.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mailcheck/mailcheck/1.91.2/mailcheck_1.91.2.tar.gz"
  sha256 "6ca6da5c9f8cc2361d4b64226c7d9486ff0962602c321fc85b724babbbfa0a5c"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a4bc1f7c913076ef17c1b531efac03d16993d206cb7ad979b21dd416ab0ff51"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78a04acdb60b3a1876761dcf587175162fa9512b795863b3e7acbe78c3d4c415"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f8feccdcd2c1ee2bed597b1195571b042969ef0a793fee7b239ab56dd6d6f3c"
    sha256 cellar: :any,                 arm64_linux:       "7893498ebc75f1b60b5fe77842113b1211b7176d16f0e457613ce6338d4414ea"
    sha256 cellar: :any,                 x86_64_linux:      "5b8bc9f845aa6912dc77eb59ab8caa16610513398f087e3f0ab213af73d146e5"
  end

  deny_network_access!

  def install
    system "make", "mailcheck"
    bin.install "mailcheck"
    man1.install "mailcheck.1"
    etc.install "mailcheckrc"
  end

  test do
    ENV["HOME"] = testpath
    %w[cur new tmp].each { |d| (testpath/"Maildir"/d).mkpath }
    touch testpath/"Maildir/new/1"
    touch testpath/"Maildir/new/2"
    touch testpath/"Maildir/cur/3"
    (testpath/".mailcheckrc").write "$(HOME)/Maildir\n"

    assert_equal "You have 2 new and 1 saved messages in #{testpath}/Maildir",
                 shell_output("#{bin}/mailcheck").strip

    # Login mode exits silently when ~/.hushlogin exists
    touch testpath/".hushlogin"
    assert_empty shell_output("#{bin}/mailcheck -l")
  end
end
