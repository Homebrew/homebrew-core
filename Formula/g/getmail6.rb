class Getmail6 < Formula
  include Language::Python::Shebang

  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "https://getmail6.org/"
  url "https://github.com/getmail6/getmail6/archive/refs/tags/v6.19.03.tar.gz"
  sha256 "b47938a23e00fe953696757dc0eacd5f6e87561aa9ca0994ad54f182a9ba29e4"
  license "GPL-2.0-only"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "237397ce5a406ac878fc92f8d5adeb4971cb97cd36a3e38b0ce33457f7094e67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "237397ce5a406ac878fc92f8d5adeb4971cb97cd36a3e38b0ce33457f7094e67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "237397ce5a406ac878fc92f8d5adeb4971cb97cd36a3e38b0ce33457f7094e67"
    sha256 cellar: :any_skip_relocation, sonoma:         "248e1a27e2f2d17270205ad9ae6fc675aa31e3887dfa29e90fd05a262b00e6fa"
    sha256 cellar: :any_skip_relocation, ventura:        "248e1a27e2f2d17270205ad9ae6fc675aa31e3887dfa29e90fd05a262b00e6fa"
    sha256 cellar: :any_skip_relocation, monterey:       "248e1a27e2f2d17270205ad9ae6fc675aa31e3887dfa29e90fd05a262b00e6fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df0a33fb1e994e807502e771416bd30f9cd25e621fcb8f8ca9716d1305a50ebf"
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
