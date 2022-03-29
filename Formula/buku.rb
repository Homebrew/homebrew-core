class Buku < Formula
  include Language::Python::Virtualenv

  desc "Powerful command-line bookmark manager"
  homepage "https://github.com/jarun/buku"
  url "https://files.pythonhosted.org/packages/94/96/1d62b1346c07f8abc661fa499fef0acc7a110735e5b768b8899e58be8dc5/buku-4.6.tar.gz"
  sha256 "e598045dc6b41121f2b706355d41e771aca9d30df71880fdeaed6f2f670d8dd8"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/jarun/buku.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "52bb407e4996fc109addb30ab9e5961f004beba214383af401679853f02f0f19"
    sha256 cellar: :any,                 arm64_big_sur:  "743eff69d09f136eb81de3494032859cb525c3df1d305244c205367ebe83c0f4"
    sha256 cellar: :any,                 monterey:       "7421df3b2e8c163debfa066a7c0e174e0b48e83d212d6ad7cca622d322179106"
    sha256 cellar: :any,                 big_sur:        "516ddf1f91c6aaddafe1769a619b211e04792b5f2f11b9e167110e991978734d"
    sha256 cellar: :any,                 catalina:       "e2e79d52393214265dd788564e207dec1d1f6ab425c7989677ec7ae605ec1b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b51c6e40256ce3cfc8b70d9a05861e51dc0cb192fe092728730a26bcaf0cac3f"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"
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
    url "https://files.pythonhosted.org/packages/25/e2/85d4a709a3ea58f8e36b4db9eb7927560a2fa4b6f8f362fb6475962fec51/arrow-1.2.1.tar.gz"
    sha256 "c2dde3c382d9f7e6922ce636bf0b318a7a853df40ecb383b29192e6c5cc82840"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/a1/69/daeee6d8f22c997e522cdbeb59641c4d31ab120aba0f2c799500f7456b7e/beautifulsoup4-4.10.0.tar.gz"
    sha256 "c23ad23c521d818955a4151a67d81580319d4bf548d3d49f4223ae041ff98891"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/68/e4/e014e7360fc6d1ccc507fe0b563b4646d00e0d4f9beec4975026dd15850b/charset-normalizer-2.0.9.tar.gz"
    sha256 "b0b883e8e874edfdece9c28f314e3dd5badf067342e42fb162203335ae61aa2c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f9/4b/1cf8e281f7ae4046a59e5e39dd7471d46db9f61bb564fddbff9084c4334f/cryptography-36.0.1.tar.gz"
    sha256 "53e5c1dc3d7a953de055d77bef2ff607ceef7a2aac0353b5d630ab67f7423638"
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
    url "https://files.pythonhosted.org/packages/db/04/8a3fb1a40ff6752d644ddd76f517cc1c2caf246f7e4d0fb2515d462388db/Flask-Admin-1.5.8.tar.gz"
    sha256 "eb06a1f31b98881dee53a55c64faebd1990d6aac38826364b280df0b2679ff74"
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
    url "https://files.pythonhosted.org/packages/23/b5/c27b414b6fa9904d31641845b0e15eab1e1e2c125c521fc1d69917ae58a8/flask-paginate-2021.10.29.tar.gz"
    sha256 "660ba1451e4cb168d3a42ed63914fe507bb5c0b30c26a6286b923077bba2362b"
  end

  resource "flask-reverse-proxy-fix" do
    url "https://files.pythonhosted.org/packages/ce/ca/8ca4a400b5effa463abe7d51db3e98485addce1f04cafc746dea662e3b07/flask-reverse-proxy-fix-0.2.1.tar.gz"
    sha256 "03ce3312d92f2b0073205e74bee1e6213640b44b1de730375d8cf478447e208c"
  end

  resource "Flask-WTF" do
    url "https://files.pythonhosted.org/packages/06/bb/090df80acb1f51ee3996d822ba34096b3e54b3af76c2c46530d6cf35c9b9/Flask-WTF-1.0.0.tar.gz"
    sha256 "872fbb17b5888bfc734edbdcf45bc08fb365ca39f69d25dc752465a455517b28"
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
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/e1/25/a3005eedafb34e1258458e8a4b94900a60a41a2b4e459e0e19631648a2a0/soupsieve-2.3.1.tar.gz"
    sha256 "b8d49b1cd4f037c7082a9683dfa1801aa2597fb11c3a1155b7a5b94829b4f1f9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
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
    url "https://files.pythonhosted.org/packages/8e/0c/4c273e88f5b5b5757b4532a0d7f1fe9fb7d9843fe57303f162daaad2b7ce/WTForms-3.0.0.tar.gz"
    sha256 "4abfbaa1d529a1d0ac927d44af8dbb9833afd910e56448a103f1893b0b176886"
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

    expect = if OS.mac?
      "/usr/bin/expect"
    else
      Formula["expect"].opt_bin/"expect"
    end

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
      expect "Generate auto-tag (YYYYMonDD)? (y/n): "
      send "y\r"
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
    system expect, "-f", "import"

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
    system expect, "-f", "crypto-test"

    # Test database content and search
    result = shell_output("#{bin}/buku --np --sany Homebrew")
    assert_match "https://github.com/Homebrew/brew", result
    assert_match "The missing package manager for macOS", result

    # Test bukuserver
    result = shell_output("#{bin}/bukuserver --version")
    assert_match version.to_s, result

    port = free_port
    fork do
      $stdout.reopen("/dev/null")
      $stderr.reopen("/dev/null")
      exec "#{bin}/bukuserver run --host 127.0.0.1 --port #{port}"
    end
    sleep 10

    result = shell_output("curl -s 127.0.0.1:#{port}/api/bookmarks")
    assert_match "https://github.com/Homebrew/brew", result
    assert_match "The missing package manager for macOS", result
  end
end
