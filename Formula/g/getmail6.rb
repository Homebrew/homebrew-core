class Getmail6 < Formula
  include Language::Python::Shebang

  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "https://getmail6.org/"
  url "https://github.com/getmail6/getmail6/archive/refs/tags/v6.19.06.tar.gz"
  sha256 "9c7f13a3f0e4345e0cfd9705f681d69aa4ba482ec656a9aea71f3e9e6d6ffb7c"
  license "GPL-2.0-only"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9bbf4c8110ea08f2c74e41950c103f6e09d8189f1a312ebeab6445fd464d2b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9bbf4c8110ea08f2c74e41950c103f6e09d8189f1a312ebeab6445fd464d2b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9bbf4c8110ea08f2c74e41950c103f6e09d8189f1a312ebeab6445fd464d2b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "da9a298711699f9dff1c11747dafc6527b8f9938632bc3cdde2998f13b20207c"
    sha256 cellar: :any_skip_relocation, ventura:       "da9a298711699f9dff1c11747dafc6527b8f9938632bc3cdde2998f13b20207c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9bbf4c8110ea08f2c74e41950c103f6e09d8189f1a312ebeab6445fd464d2b9"
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
