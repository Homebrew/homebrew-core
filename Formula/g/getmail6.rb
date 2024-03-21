class Getmail6 < Formula
  include Language::Python::Shebang

  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "https://getmail6.org/"
  url "https://github.com/getmail6/getmail6/archive/refs/tags/v6.18.14.tar.gz"
  sha256 "0667efc80d7a59c4528581829f2c7473a7703c680a8fc941254ed872d15721b0"
  license "GPL-2.0-only"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70df6a193df6a6444a8b2178a896d5a50e64f3a36f19d0321dde9293e8d95e29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70df6a193df6a6444a8b2178a896d5a50e64f3a36f19d0321dde9293e8d95e29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70df6a193df6a6444a8b2178a896d5a50e64f3a36f19d0321dde9293e8d95e29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70df6a193df6a6444a8b2178a896d5a50e64f3a36f19d0321dde9293e8d95e29"
    sha256 cellar: :any_skip_relocation, sonoma:         "8eafc1243b58796239f1e24d45f124dcc3f1e9373011a4e00db831f11326421d"
    sha256 cellar: :any_skip_relocation, ventura:        "8eafc1243b58796239f1e24d45f124dcc3f1e9373011a4e00db831f11326421d"
    sha256 cellar: :any_skip_relocation, monterey:       "8eafc1243b58796239f1e24d45f124dcc3f1e9373011a4e00db831f11326421d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8eafc1243b58796239f1e24d45f124dcc3f1e9373011a4e00db831f11326421d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70df6a193df6a6444a8b2178a896d5a50e64f3a36f19d0321dde9293e8d95e29"
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
