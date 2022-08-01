class Buku < Formula
  include Language::Python::Virtualenv

  desc "Powerful command-line bookmark manager"
  homepage "https://github.com/jarun/buku"
  url "https://files.pythonhosted.org/packages/7a/b7/5268eacdbb0829039b1039f58bedab03e2139ec2d242094f8c062d792277/buku-4.7.1.tar.gz"
  sha256 "e7f3a1024a4b926e4480a32cb798f0ce3501961efcd15442616cfebeb777c916"
  license "GPL-3.0-or-later"
  head "https://github.com/jarun/buku.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "039f97def4d5bfffb21d4730d5da3e3dff0f372ab788f8236370c3f89682c67c"
    sha256 cellar: :any,                 arm64_big_sur:  "e991364f67cd37d23bea553024a4c8a8ef5155743c4e330030ead739776463d2"
    sha256 cellar: :any,                 monterey:       "1f836bd7e6c279206ad81a0e98b84fa28281b7da106a6d8098c30cf896a6f031"
    sha256 cellar: :any,                 big_sur:        "a2ff138cf3782813ec2ae1c3bf2b91bb71135f9ba040e3d5bdf2bd0ade48a389"
    sha256 cellar: :any,                 catalina:       "c6055fa2a2967754606d439eccec3ecc8422f0d9797c0231e6de040ec26ceeec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5173a7cbb03169a89f0dc5f744ff4fc920fa873668f1dba2e940d3f9bdef68d6"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "expect" => :test
  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/48/28/30a5748af715b0ab9c2b81cf08bd9e261e47a6261e247553afb7f6421b24/arrow-1.2.2.tar.gz"
    sha256 "05caf1fd3d9a11a1135b2b6f09887421153b94558e5ef4d090b567b47173ac2b"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/e8/b0/cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7/beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/89/d9/5fcd312d5cce0b4d7ee8b551a0ea99e4ea9db0fdbf6dd455a19042e3370b/cryptography-37.0.4.tar.gz"
    sha256 "63f9c17c0e2474ccbebc9302ce2f07b55b3b3fcb211ded18a42d5764f5c10a82"
  end

  resource "dominate" do
    url "https://files.pythonhosted.org/packages/29/23/edf8e470f1053245c1aa99d92c8a3da9e83f6c7d3eb39205486965425be5/dominate-2.6.0.tar.gz"
    sha256 "76ec2cde23700a6fc4fee098168b9dee43b99c2f1dd0ca6a711f683e8eb7e1e4"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/4d/5b/2d145f5fe718b2f15ebe69240538f06faa8bbb76488bf962091db1f7a26d/Flask-1.1.4.tar.gz"
    sha256 "0fbeb6180d383a9186d0d6ed954e0042ad9f18e0e8de088b2b419d526927d196"
  end

  resource "Flask-Admin" do
    url "https://files.pythonhosted.org/packages/d4/cb/2f0b363a818ca756eb9931a5af3ce216e497b6a4edc8caf130310dd1e36c/Flask-Admin-1.6.0.tar.gz"
    sha256 "424ffc79b7b0dfff051555686ea12e86e48dffacac14beaa319fb4502ac40988"
  end

  resource "Flask-API" do
    url "https://files.pythonhosted.org/packages/41/3b/85c631237164be518c1d91fba082eda171e44d88f394e2a884b3c2a7113f/Flask-API-2.0.tar.gz"
    sha256 "6986642e5b25b7def710ca9489ed2b88c94006bfc06eca01c78da7cf447e66e5"
  end

  resource "Flask-Bootstrap" do
    url "https://files.pythonhosted.org/packages/88/53/958ce7c2aa26280b7fd7f3eecbf13053f1302ee2acb1db58ef32e1c23c2a/Flask-Bootstrap-3.3.7.1.tar.gz"
    sha256 "cb08ed940183f6343a64e465e83b3a3f13c53e1baabb8d72b5da4545ef123ac8"
  end

  resource "flask-paginate" do
    url "https://files.pythonhosted.org/packages/6a/2c/79a20c141c58f0993f3e40e280376618800e3cd5a503cacf7db84e4785dc/flask-paginate-2022.1.8.tar.gz"
    sha256 "a32996ec07ca004c45b768b0d50829728ab8f3986c0650ef538e42852c7aeba2"
  end

  resource "flask-reverse-proxy-fix" do
    url "https://files.pythonhosted.org/packages/ce/ca/8ca4a400b5effa463abe7d51db3e98485addce1f04cafc746dea662e3b07/flask-reverse-proxy-fix-0.2.1.tar.gz"
    sha256 "03ce3312d92f2b0073205e74bee1e6213640b44b1de730375d8cf478447e208c"
  end

  resource "Flask-WTF" do
    url "https://files.pythonhosted.org/packages/d9/38/d4798dd05be711d666e1befb08b1d3db57bd146d1a14d15657f60c88b446/Flask-WTF-1.0.1.tar.gz"
    sha256 "34fe5c6fee0f69b50e30f81a3b7ea16aa1492a771fe9ad0974d164610c09a6c9"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/68/1a/f27de07a8a304ad5fa817bbe383d1238ac4396da447fa11ed937039fa04b/itsdangerous-1.1.0.tar.gz"
    sha256 "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/25/36/f056e5f1389004cf886bb7a8514077f24224238a7534497c014a6b9ac770/urllib3-1.26.10.tar.gz"
    sha256 "879ba4d1e89654d9769ce13121e0f94310ea32e8d2f8cf587b77c08bbcdb30d6"
  end

  resource "visitor" do
    url "https://files.pythonhosted.org/packages/d7/58/785fcd6de4210049da5fafe62301b197f044f3835393594be368547142b0/visitor-0.1.3.tar.gz"
    sha256 "2c737903b2b6864ebc6167eef7cf3b997126f1aa94bdf590f90f1436d23e480a"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/10/27/a33329150147594eff0ea4c33c2036c0eadd933141055be0ff911f7f8d04/Werkzeug-1.0.1.tar.gz"
    sha256 "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c"
  end

  resource "WTForms" do
    url "https://files.pythonhosted.org/packages/9a/7d/d4aa68f5bfcb91dd61a7faf0e862512ae7b3d531c41f24c217910aec0559/WTForms-3.0.1.tar.gz"
    sha256 "6b351bbb12dd58af57ffef05bc78425d08d1914e0fd68ee14143b7ade023c5bc"
  end

  def install
    virtualenv_install_with_resources
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

    system bin/"buku", "--nostdin", "--nc", "--tacit", "--import", "bookmarks.html"
    assert_equal <<~EOS, shell_output("#{bin}/buku --nostdin --nc --print").chomp
      1. Title unknown
         > https://github.com/Homebrew/brew
         # bookmarks toolbar
    EOS

    # Test online components -- fetch titles
    assert_match "Index 1: updated", shell_output("#{bin}/buku --nostdin --nc --update")

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
    system "expect", "-f", "crypto-test"

    # Test database content and search
    result = shell_output("#{bin}/buku --np --sany Homebrew")
    assert_match "https://github.com/Homebrew/brew", result
    assert_match "The missing package manager for macOS", result

    # Test bukuserver
    result = shell_output("#{bin}/bukuserver --version")
    assert_match version.to_s, result

    port = free_port
    pid = fork do
      $stdout.reopen("/dev/null")
      $stderr.reopen("/dev/null")
      exec "#{bin}/bukuserver", "run", "--host", "127.0.0.1", "--port", port.to_s
    end

    begin
      sleep 10
      result = shell_output("curl -s 127.0.0.1:#{port}/api/bookmarks")
      assert_match "https://github.com/Homebrew/brew", result
      assert_match "The missing package manager for macOS", result
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
