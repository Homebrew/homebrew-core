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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "766eae979bf0fee2bb6d3dab837d834cc128b39733ffc8a3a00f16d6d78220b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "766eae979bf0fee2bb6d3dab837d834cc128b39733ffc8a3a00f16d6d78220b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "766eae979bf0fee2bb6d3dab837d834cc128b39733ffc8a3a00f16d6d78220b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "06e6cf1500be762382fa1652568a0e864845c7c89ccfcd51725199a92260a624"
    sha256 cellar: :any_skip_relocation, ventura:        "06e6cf1500be762382fa1652568a0e864845c7c89ccfcd51725199a92260a624"
    sha256 cellar: :any_skip_relocation, monterey:       "06e6cf1500be762382fa1652568a0e864845c7c89ccfcd51725199a92260a624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "766eae979bf0fee2bb6d3dab837d834cc128b39733ffc8a3a00f16d6d78220b8"
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
