class Getmail6 < Formula
  include Language::Python::Shebang

  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "https://getmail6.org/"
  url "https://github.com/getmail6/getmail6/archive/refs/tags/v6.19.01.tar.gz"
  sha256 "b1249eaeb84ddd325e84fe5afd24eb99d1f79e930ff3114c2b049cc7e1942f1c"
  license "GPL-2.0-only"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c221093c7287e376c5043d86bf05a539e41579ca47525d066b316c3d619db0d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c221093c7287e376c5043d86bf05a539e41579ca47525d066b316c3d619db0d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c221093c7287e376c5043d86bf05a539e41579ca47525d066b316c3d619db0d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa1ffdb2f77abb724c8b222ac921aed3a08bccb61b0195181306f6b6c3bef146"
    sha256 cellar: :any_skip_relocation, ventura:        "fa1ffdb2f77abb724c8b222ac921aed3a08bccb61b0195181306f6b6c3bef146"
    sha256 cellar: :any_skip_relocation, monterey:       "fa1ffdb2f77abb724c8b222ac921aed3a08bccb61b0195181306f6b6c3bef146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "168bb608782c59486f66c83ba1ec2ffee73e4c2b13ab0c3f940c2afdfa4d7c9c"
  end

  uses_from_macos "python", since: :catalina

  def install
    files = %w[getmail getmail_fetch getmail_maildir getmail_mbox]
    rewrite_shebang detected_python_shebang(use_python_from_path: true), *files
    libexec.install files
    bin.install_symlink libexec.children
    libexec.install "getmailcore"
    man1.install Pathname.glob("docs/*.1")
  end

  test do
    %w[INBOX/cur INBOX/new INBOX/tmp].each { |f| (testpath/"getmail/#{f}").mkpath }
    (testpath/"getmail/getmailrc").write <<~EOS
      [retriever]
      type = SimpleIMAPSSLRetriever
      server = imap.gmail.com
      port = 993
      username = test@brew.sh
      #password = ... or
      password_command = ("pass", "test@brew.sh")

      [destination]
      type = Maildir
      path = #{testpath}/getmail/INBOX/

      [options]
      read_all = true
      delete = true
    EOS
    output = shell_output("#{bin}/getmail --getmaildir #{testpath}/getmail 2>&1", 2)
    assert_match "Program \"pass\" not found", output

    assert_match version.to_s, shell_output("#{bin}/getmail --version")
  end
end
