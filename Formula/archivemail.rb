class Archivemail < Formula
  desc "Tool for archiving and compressing old email in mailboxes"
  homepage "https://archivemail.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/archivemail/archivemail-0.9.0.tar.gz"
  sha256 "4b430e2fba6f24970a67bd61eef39d7eae8209c7bef001196b997be1916fc663"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e6bd3c6cb9f2737aff513617d4921ed09d434685c1b6e4cd132a58a47dae3274" => :catalina
    sha256 "33c0fd2530ac1f0d09ff9c357ea3cbd8774e05c1f78b7d73e9674af9b5ab3b42" => :mojave
    sha256 "fdcee6cb204a8b0aeacb9d3774d782013b2a53e87c0f2995d939f00f7fe669e4" => :high_sierra
    sha256 "fdcee6cb204a8b0aeacb9d3774d782013b2a53e87c0f2995d939f00f7fe669e4" => :sierra
  end

  depends_on "python@2" # does not support Python 3

  def install
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir[libexec/"share/man/man1/*"]
  end

  test do
    (testpath/"inbox").write <<~EOS
      From MAILER-DAEMON Fri Jul  8 12:08:34 2011
      From: Author <author@example.com>
      To: Recipient <recipient@example.com>
      Subject: Sample message 1

      This is the body.

      From MAILER-DAEMON Fri Jul  8 12:08:34 2012
      From: Author <author@example.com>
      To: Recipient <recipient@example.com>
      Subject: Sample message 2

      This is the second body.
    EOS
    system bin/"archivemail", "--no-compress", "--date", "2012-01-01", (testpath/"inbox")
    assert_predicate testpath/"inbox_archive", :exist?
    assert_match "Sample message 1", File.read("inbox_archive")
    assert !File.read("inbox").include?("Sample message 1")
    assert_match "Sample message 2", File.read("inbox")
  end
end
