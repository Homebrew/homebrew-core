class Buku < Formula
  include Language::Python::Virtualenv

  desc "Command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/v2.6.tar.gz"
  sha256 "ac83a2d104ca632352262613fa92a6293a84e31b00dab24fa90448e71ec6106e"
  revision 1

  bottle do
    sha256 "4ef900f3e72970f988912de8a21d214c63bcdcc5a1ac80abb03c9506e470584e" => :sierra
    sha256 "805c1d00f759d1edd43a2ce84502f7a19c6d9cf66da56caa7f4a189208524f57" => :el_capitan
    sha256 "8aaaa375254a5e92349cd502e43160938e414587210b3d01ea0f1414c67d7bf1" => :yosemite
  end

  depends_on :python3
  depends_on "openssl@1.1"

  # beautifulsoup4

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/86/ea/8e9fbce5c8405b9614f1fd304f7109d9169a3516a493ce4f7f77c39435b7/beautifulsoup4-4.5.1.tar.gz"
    sha256 "3c9474036afda9136aac6463def733f81017bf9ef3510d25634f335b0c87f5e1"
  end

  # cryptography

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/0a/f3/686af8873b70028fccf67b15c78fd4e4667a3da995007afc71e786d61b0a/cffi-1.8.3.tar.gz"
    sha256 "c321bd46faa7847261b89c0469569530cad5a41976bb6dba8202c0159f476568"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6c/c5/7fc1f8384443abd2d71631ead026eb59863a58cad0149b94b89f08c8002f/cryptography-1.5.3.tar.gz"
    sha256 "cf82ddac919b587f5e44247579b433224cc2e03332d2ea4d89aa70d7e6b64ae5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    # Replace shebang with virtualenv python
    inreplace "buku", "#!/usr/bin/env python3", "#!#{libexec}/bin/python"

    bin.install "buku"
    man1.install "buku.1"
    bash_completion.install "auto-completion/bash/buku-completion.bash"
    fish_completion.install "auto-completion/fish/buku.fish"
    zsh_completion.install "auto-completion/zsh/_buku"
  end

  test do
    ENV["XDG_DATA_HOME"] = "#{testpath}/.local/share"

    # Firefox exported bookmarks file
    (testpath/"bookmarks.html").write <<-EOS.undent
      <!DOCTYPE NETSCAPE-Bookmark-file-1>
      <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
      <TITLE>Bookmarks</TITLE>
      <H1>Bookmarks Menu</H1>

      <DL><p>
          <HR>    <DT><H3 ADD_DATE="1464091987" LAST_MODIFIED="1477369518" PERSONAL_TOOLBAR_FOLDER="true">Bookmarks Toolbar</H3>
          <DD>Add bookmarks to this folder to see them displayed on the Bookmarks Toolbar
          <DL><p>
              <DT><A HREF="https://github.com/Homebrew/brew" ADD_DATE="1477369518" LAST_MODIFIED="1477369529">Homebrew</A>
          </DL><p>
      </DL>
    EOS

    assert_match "https://github.com/Homebrew/brew", shell_output("#{bin}/buku --import bookmarks.html")

    # Test crypto functionality
    (testpath/"crypto-test").write <<-EOS.undent
      # Lock bookmark database
      spawn buku -l
      expect "Password: "
      send "password\r"
      expect "Password: "
      send "password\r"
      expect {
          -re ".*ERROR.*" { exit 1 }
          "File encrypted"
      }

      # Unlock bookmark database
      spawn buku -k
      expect "Password: "
      send "password\r"
      expect {
          -re ".*ERROR.*" { exit 1 }
          "File decrypted"
      }
    EOS
    system "/usr/bin/expect", "-f", "crypto-test"

    assert_match "https://github.com/Homebrew/brew", shell_output("#{bin}/buku --noprompt -s github")
  end
end
