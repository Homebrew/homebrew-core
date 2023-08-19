class Getmail6 < Formula
  include Language::Python::Shebang

  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "https://getmail6.org/"
  url "https://github.com/getmail6/getmail6/archive/refs/tags/v6.18.12.tar.gz"
  sha256 "419dc11184b147ef4daac2ec9f136b1b37e6450e2f44099629a6b7650deb044a"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b78657f43b1b31999bdec34a6919fe344b3287e9c41abed5b8091c3b116f530"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b78657f43b1b31999bdec34a6919fe344b3287e9c41abed5b8091c3b116f530"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b78657f43b1b31999bdec34a6919fe344b3287e9c41abed5b8091c3b116f530"
    sha256 cellar: :any_skip_relocation, ventura:        "ed5dd093960948c844fca55dddc1be98f740e43fa4e84f55f84ab92b6df00265"
    sha256 cellar: :any_skip_relocation, monterey:       "ed5dd093960948c844fca55dddc1be98f740e43fa4e84f55f84ab92b6df00265"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed5dd093960948c844fca55dddc1be98f740e43fa4e84f55f84ab92b6df00265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b78657f43b1b31999bdec34a6919fe344b3287e9c41abed5b8091c3b116f530"
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
