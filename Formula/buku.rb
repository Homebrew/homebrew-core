class Buku < Formula
  include Language::Python::Virtualenv

  desc "Powerful command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/v3.5.tar.gz"
  sha256 "b758924b78a45d39e6d8e16915f2df17a7e7d5e184a876819c6aa612cd73fc05"

  bottle do
    cellar :any
    sha256 "61d91dfd1a0c8504b2bb7ad33a71838e031b200620142597faf8665d8e1edfac" => :high_sierra
    sha256 "eb92d3fdff36d4e2591d63a3c85251c76e8bf46f025ec88a9859ea8efe434bb6" => :sierra
    sha256 "96925b5a253c02f6e3aa59698b39b01b5df3843eef556084168b9da8a23de933" => :el_capitan
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
    url "https://files.pythonhosted.org/packages/4e/32/4070bdf32812c89eb635c80880a5caa2e0189aa7999994c265577e5154f3/cffi-1.11.0.tar.gz"
    sha256 "5f4ff33371c6969b39b293d9771ee91e81d26f9129be093ca1b7be357fcefd15"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9c/1a/0fc8cffb04582f9ffca61b15b0681cf2e8588438e55f61403eb9880bd8e0/cryptography-2.0.3.tar.gz"
    sha256 "d04bb2425086c3fe86f7bc48915290b13e798497839fbb18ab7f6dffcf98cc3a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
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
    (testpath/"bookmarks.html").write <<~EOS
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

    (testpath/"import").write <<~EOS
      spawn #{bin}/buku --nc --import bookmarks.html
      expect -re "DB file is being created at .*"
      expect "You should encrypt it."
      expect "Add parent folder names as tags? (y/n): "
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
    (testpath/"crypto-test").write <<~EOS
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
