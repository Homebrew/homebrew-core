class Getmail6 < Formula
  include Language::Python::Shebang

  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "https://getmail6.org/"
  url "https://github.com/getmail6/getmail6/archive/refs/tags/v6.20.00.tar.gz"
  sha256 "a78ce1f02a35c1aed95d6fd8bc9db47e514247ec66a87e00ef9eda80d800d9ad"
  license "GPL-2.0-only"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8cd5b0c2f2645f5102d69c7231e8acbc3d560160e2c075d90cb36ef151e2dc67"
  end

  uses_from_macos "python"

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
