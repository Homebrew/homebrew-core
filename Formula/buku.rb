class Buku < Formula
  include Language::Python::Virtualenv

  desc "Powerful command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/v4.2.2.tar.gz"
  sha256 "08866f284a03454d9ee5bbb332da62e6ae1dfbe83ada75092453a7fd04fe62b3"
  revision 1

  bottle do
    cellar :any
    sha256 "0af777ba94a4c830808ef8107ed97636e7ae2cf6a6b69a63403bdbe5f0f1d0b6" => :mojave
    sha256 "d7895d98cc003535022ccc3795bc7ae18ee438a8c1989af912d7d6c7f010ffd9" => :high_sierra
    sha256 "2d4aa8647d31246d9152770fe786e31ed153c6437c10e0a8abbb661318eaa03e" => :sierra
  end

  depends_on "openssl@1.1"
  depends_on "python"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/80/f2/f6aca7f1b209bb9a7ef069d68813b091c8c3620642b568dac4eb0e507748/beautifulsoup4-4.7.1.tar.gz"
    sha256 "945065979fb8529dd2f37dbb58f00b661bdbcbebf954f93b32fdf5263ef35348"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/55/54/3ce77783acba5979ce16674fc98b1920d00b01d337cfaaf5db22543505ed/certifi-2018.11.29.tar.gz"
    sha256 "47f9c83ef4c0c621eaef743f133f09fa8a74a9b75f037e8624f83bd1b6626cb7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f3/39/d3904df7c56f8654691c4ae1bdb270c1c9220d6da79bd3b1fbad91afd0e1/cryptography-2.4.2.tar.gz"
    sha256 "05a6052c6a9f17ff78ba78f8e6eb1d777d25db3b763343a1ae89a7a8670386dd"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/85/3e/cf449cf1b5004e87510b9368e7a5f1acd8831c2d6691edd3c62a0823f98f/html5lib-1.0.1.tar.gz"
    sha256 "66cb0dcfdbbc4f9c3ba1a63fdb511ffdbd4f513b2b6d81b80cd26ce6b3fb3736"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/10/e5/ba6dae356c1ca793c08b2017e27cb43199c0fd8b18595e8abf977bbc8d5f/soupsieve-1.7.2.tar.gz"
    sha256 "10687fc53eeb3518e01a0ac84d3d711da623d3298a3039459d3f649927c4a270"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b1/53/37d82ab391393565f2f831b8eedbffd57db5a718216f82f1a8b4d381a1c1/urllib3-1.24.1.tar.gz"
    sha256 "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
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
      expect "Append tags when bookmark exist? (y/n): "
      send "y\r"
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
