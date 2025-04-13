class Getmail6 < Formula
  include Language::Python::Shebang

  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "https://getmail6.org/"
  url "https://github.com/getmail6/getmail6/archive/refs/tags/v6.19.07.tar.gz"
  sha256 "afc7c7dd061fccab2968b4b0a30ea025c7123a4722ea0a73fb6e3f9e6d8250cd"
  license "GPL-2.0-only"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2843d92bd2232d2eb6724039244e47b721cb294624236ff58ac044a866f52c4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2843d92bd2232d2eb6724039244e47b721cb294624236ff58ac044a866f52c4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2843d92bd2232d2eb6724039244e47b721cb294624236ff58ac044a866f52c4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "75b2ea3d0465fcdedf0ac2748f1987772f1f3e09b243e0630a6616bda036654f"
    sha256 cellar: :any_skip_relocation, ventura:       "75b2ea3d0465fcdedf0ac2748f1987772f1f3e09b243e0630a6616bda036654f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2843d92bd2232d2eb6724039244e47b721cb294624236ff58ac044a866f52c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2843d92bd2232d2eb6724039244e47b721cb294624236ff58ac044a866f52c4d"
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
