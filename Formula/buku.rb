class Buku < Formula
  include Language::Python::Virtualenv

  desc "Command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/v3.2.tar.gz"
  sha256 "2375fc22e7e417fe23814589257f007cfdc1b1e3f8e47619a7d6e83ff0fb4f09"

  bottle do
    cellar :any
    sha256 "d3152fb70915fcf421f71494a9437b2dbb97d0e02474e4cbca802366a9397dd8" => :sierra
    sha256 "d5806cf3a57448deae4b6147f85289bc5f538fab8e296e535c16fb87d7799fb9" => :el_capitan
    sha256 "22a53c0e1a1bf38695019bd978c3bc23a90aec5db278cd31570a6724acf09ea9" => :yosemite
  end

  depends_on :python3
  depends_on "openssl@1.1"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/67/14/5d66588868c4304f804ebaff9397255f6ec5559e46724c2496e0f26e68d6/asn1crypto-0.22.0.tar.gz"
    sha256 "cbbadd640d3165ab24b06ef25d1dca09a3441611ac15f6a6b452474fdf0aed1a"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/fa/8d/1d14391fdaed5abada4e0f63543fef49b8331a34ca60c88bd521bcf7f782/beautifulsoup4-4.6.0.tar.gz"
    sha256 "808b6ac932dccb0a4126558f7dfdcf41710dd44a4ef497a0bb59a77f9f078e89"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/20/d0/3f7a84b0c5b89e94abbd073a5f00c7176089f526edb056686751d5064cbd/certifi-2017.7.27.1.tar.gz"
    sha256 "40523d2efb60523e113b44602298f0960e900388cf3bb6043f645cf57ea9e3f5"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/5b/b9/790f8eafcdab455bcd3bd908161f802c9ce5adbf702a83aa7712fcc345b7/cffi-1.10.0.tar.gz"
    sha256 "b3b02911eb1f6ada203b0763ba924234629b51586f72a21faacc638269f4ced5"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/2a/0c/31bd69469e90035381f0197b48bf71032991d9f07a7e444c311b4a23a3df/cryptography-1.9.tar.gz"
    sha256 "5518337022718029e367d982642f3e3523541e098ad671672a90b82474c84882"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c3/38/d95ddb6cc8558930600be088e174a2152261a1e0708a18bf91b5b8c90b22/requests-2.18.3.tar.gz"
    sha256 "fb68a7baef4965c12d9cd67c0f5a46e6e28be3d8c7b6910c758fbcc99880b518"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    # Replace shebang with virtualenv python
    inreplace "buku.py", "#!/usr/bin/env python3", "#!#{libexec}/bin/python"

    bin.install "buku.py" => "buku"
    man1.install "buku.1"
    bash_completion.install "auto-completion/bash/buku-completion.bash"
    fish_completion.install "auto-completion/fish/buku.fish"
    zsh_completion.install "auto-completion/zsh/_buku"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
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
              <DT><A HREF="https://github.com/Homebrew/brew" ADD_DATE="1477369518" LAST_MODIFIED="1477369529">Title unknown</A>
          </DL><p>
      </DL>
    EOS

    (testpath/"import").write <<-EOS.undent
      spawn #{bin}/buku --nc --import bookmarks.html
      expect "Specify unique tag for imports (Enter to skip): "
      send "\r"
      expect "Add imported folders names as tags? (y/n): "
      send "y\r"
      expect {
          -re ".*ERROR.*" { exit 1 }
          "1. Title unknown"
      }
      spawn sleep 5
    EOS
    system "/usr/bin/expect", "-f", "import"

    # Test online components -- fetch titles
    system bin/"buku", "--update"

    # Test crypto functionality
    (testpath/"crypto-test").write <<-EOS.undent
      # Lock bookmark database
      spawn #{bin}/buku --lock
      expect "Password: "
      send "password\r"
      expect "Password: "
      send "password\r"
      expect {
          -re ".*ERROR.*" { exit 1 }
          "File encrypted"
      }

      # Unlock bookmark database
      spawn #{bin}/buku --unlock
      expect "Password: "
      send "password\r"
      expect {
          -re ".*ERROR.*" { exit 1 }
          "File decrypted"
      }
    EOS
    system "/usr/bin/expect", "-f", "crypto-test"

    # Test database content and search
    result = shell_output("#{bin}/buku --np --sany Homebrew")
    assert_match "https://github.com/Homebrew/brew", result
    assert_match "The missing package manager for macOS", result
  end
end
