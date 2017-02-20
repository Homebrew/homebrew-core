class Buku < Formula
  include Language::Python::Virtualenv

  desc "Command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/v2.9.tar.gz"
  sha256 "d4175aab5fab72d41cd646f688311bc347d5fcdad23dc58ee87dffb695c5a51b"

  bottle do
    sha256 "31f5326033b1b480eba89bdf169f6c02d50d9b014f704b1af7bdc99b4582e425" => :sierra
    sha256 "f0e0a0877ca23fa2411b045e6560f8df4081a4949f9cc667791f0d9a7393025b" => :el_capitan
    sha256 "eafdcf155f5edb4899ca8a541e2b7adfb63025a89175594c310df1b262c9b8b0" => :yosemite
  end

  depends_on :python3
  depends_on "openssl@1.1"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/9b/a5/c6fa2d08e6c671103f9508816588e0fb9cec40444e8e72993f3d4c325936/beautifulsoup4-4.5.3.tar.gz"
    sha256 "b21ca09366fa596043578fd4188b052b46634d22059e68dd0077d9ee77e08a3e"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/99/df/71c7260003f5c469cec3db4c547115df39e9ce6c719a99e067ba0e78fd8a/cryptography-1.7.2.tar.gz"
    sha256 "878cb68b3da3d493ffd68f36db11c29deee623671d3287c3f8d685117ffda9a9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/94/fe/efb1cb6f505e1a560b3d080ae6b9fddc11e7c542d694ce4635c49b1ccdcb/idna-2.2.tar.gz"
    sha256 "0ac27740937d86850010e035c6a10a564158a5accddf1aa24df89b0309252426"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/57/f7/c18a86169bb9995a69195177b23e736776b347fd92592da0c3cac9f1a724/pyasn1-0.2.2.tar.gz"
    sha256 "6b42f96b942406712e0be5ea2bbbc57d8f30c7835a4904c9c195cc669736d435"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/16/09/37b69de7c924d318e51ece1c4ceb679bf93be9d05973bb30c35babd596e2/requests-2.13.0.tar.gz"
    sha256 "5722cd09762faa01276230270ff16af7acf7c5c45d623868d9ba116f15791ce8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/20/56/a6aa403b0998f857b474a538343ee483f5c02491bd1aebf61d42a3f60f77/urllib3-1.20.tar.gz"
    sha256 "97ef2b6e2878d84c0126b9f4e608e37a951ca7848e4855a7f7f4437d5c34a72f"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    resource("cryptography").stage do
      if MacOS.version < :sierra
        # Fixes .../cryptography/hazmat/bindings/_openssl.so: Symbol not found: _getentropy
        # Reported 20 Dec 2016 https://github.com/pyca/cryptography/issues/3332
        inreplace "src/_cffi_src/openssl/src/osrandom_engine.h",
          "#elif defined(BSD) && defined(SYS_getentropy)",
          "#elif defined(BSD) && defined(SYS_getentropy) && 0"
      end
      venv.pip_install Pathname.pwd
    end

    other_resources = resources.map(&:name).to_set - ["cryptography"]
    other_resources.each do |r|
      venv.pip_install resource(r)
    end

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
    system bin/"buku", "--import", "bookmarks.html"

    # Test online components -- fetch titles
    system bin/"buku", "--update"

    # Test crypto functionality
    (testpath/"crypto-test").write <<-EOS.undent
      # Lock bookmark database
      spawn buku --lock
      expect "Password: "
      send "password\r"
      expect "Password: "
      send "password\r"
      expect {
          -re ".*ERROR.*" { exit 1 }
          "File encrypted"
      }

      # Unlock bookmark database
      spawn buku --unlock
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
