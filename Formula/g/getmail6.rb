class Getmail6 < Formula
  include Language::Python::Shebang

  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "https://getmail6.org/"
  url "https://github.com/getmail6/getmail6/archive/refs/tags/v6.19.08.tar.gz"
  sha256 "f0e00a679b21d274179418f8f931defa92352d92fa3a8ad651d0de6b5e93ae77"
  license "GPL-2.0-only"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeba8c126c3373e1e43aac701ea953b1ab0fdd487693bec81b0aaf069cb408a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeba8c126c3373e1e43aac701ea953b1ab0fdd487693bec81b0aaf069cb408a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aeba8c126c3373e1e43aac701ea953b1ab0fdd487693bec81b0aaf069cb408a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8193735e7a29f0906ea8bfa88062a69dd29397fab794c7a0aba470028a3be6a2"
    sha256 cellar: :any_skip_relocation, ventura:       "8193735e7a29f0906ea8bfa88062a69dd29397fab794c7a0aba470028a3be6a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeba8c126c3373e1e43aac701ea953b1ab0fdd487693bec81b0aaf069cb408a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeba8c126c3373e1e43aac701ea953b1ab0fdd487693bec81b0aaf069cb408a2"
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
