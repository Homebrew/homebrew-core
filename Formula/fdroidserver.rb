class Fdroidserver < Formula
  include Language::Python::Virtualenv

  desc "Create and manage Android app repositories for F-Droid"
  homepage "https://f-droid.org"
  url "https://files.pythonhosted.org/packages/f9/d1/e678a7abde4b93225d7496d1f511c923fa4631536f1ef559ed9383013032/fdroidserver-2.1.1.tar.gz"
  sha256 "b5d5bc7db619a54472a2d854320de1aadfd0f50baf5ce5a2069d3f72e934d265"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "aabf5a4ec122ead22260c820d4b77ba165ebf9f018cc9853bc13807fe71785f6"
    sha256 cellar: :any,                 arm64_big_sur:  "b8da9155233ad01230ec7cbf6cac9db6b57eee5394cddfd55c02e77c1c43786c"
    sha256 cellar: :any,                 monterey:       "e7d9a5ebcc36d15e5c604a961054a8e1820bc7030e195b5b61b35cf0d064d9ec"
    sha256 cellar: :any,                 big_sur:        "08165659484007c7357e3072219418f8c477fd8a3083367b654f9e77260b25c4"
    sha256 cellar: :any,                 catalina:       "df47ff62d096677ff79a374fcbce71956d94c8457fd96c6f9472f496ed423b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df51060ba670890cd63a336fbaaf34e9b783490628ce0e1d28a9b35b7a6a6e47"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "fonttools"
  depends_on "ipython"
  depends_on "numpy"
  depends_on "openssl@1.1"
  depends_on "pillow"
  depends_on "pygments"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "s3cmd"
  depends_on "six"
  depends_on "yamllint"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "androguard" do
    url "https://files.pythonhosted.org/packages/83/78/0f44e8f0fd10493b3118d79d60599c93e5a2cd378d83054014600a620cba/androguard-3.3.5.tar.gz"
    sha256 "f0655ca3a5add74c550951e79bd0bebbd1c5b239178393d30d8db0bd3202cda2"
  end

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/a0/56/4b4dc46637b6abe2362d7b802bf3d71b1cf2b72c5dd2ca05c1f9fd18b846/apache-libcloud-3.6.0.tar.gz"
    sha256 "4a3b9141033798e4fb07886ff26254e635e022acbdd708375eac6f56e323506c"
  end

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "backcall" do
    url "https://files.pythonhosted.org/packages/a2/40/764a663805d84deee23043e1426a9175567db89c8b3287b5c2ad9f71aa93/backcall-0.2.0.tar.gz"
    sha256 "5cbdbf27be5e7cfadb448baf0aa95508f91f2bbc6c6437cd9cd06e2a4c215e1e"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/99/f2/b71b9b5b2400fffac7d42c560ac89f302c4d8e328337b2f05f0a4d9e590d/bcrypt-4.0.0.tar.gz"
    sha256 "c59c170fc9225faad04dde1ba61d85b413946e8ce2e5f5f5ff30dfd67283f319"
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
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/53/e6/9a144127f3a1c1e6d9c4d305390d82a38e9e0fc7e34166c44f59a1576247/cryptography-38.0.0.tar.gz"
    sha256 "24d4137f3118900db02a2ec9a585d6dec2e79697fc90e84f19e5462dd1eeca44"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/34/45/a7caaacbfc2fa60bee42effc4bcc7d7c6dbe9c349500e04f65a861c15eb9/cycler-0.11.0.tar.gz"
    sha256 "9c87405839a19696e837b3b818fed3f5f69f16f1eec1a1ad77e043dcea9c772f"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/d6/39/5b91b6c40570dc1c753359de7492404ba8fe7d71af40b618a780c7ad1fc7/GitPython-3.1.27.tar.gz"
    sha256 "1c885ce809e8ba2d88a29befeb385fcea06338d3640712b59ca623c220bb5704"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/5f/5c/272a7dd49a1914f35cd8d6d9f386defa8b047f6fbd06badd6b77b3ba24e7/kiwisolver-1.4.4.tar.gz"
    sha256 "d41997519fcba4a1e46eb4a2fe31bc12f0ff957b2b81bac28db24744f333e955"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/02/81/e8276ec6ca005b3b2bfaaad0ea47dbb3a0e389ec8ab87d08e3ccbe4b2742/matplotlib-3.5.3.tar.gz"
    sha256 "339cac48b80ddbc8bfd05daae0a3a73414651a8596904c2a881cfd1edb65f26c"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/d9/c6/ad9dc9195c0e5d8879d2a28667aa45e087631576b40f9c954a086693a36d/networkx-2.8.6.tar.gz"
    sha256 "bd2b7730300860cbd2dafe8e5af89ff5c9a65c3975b352799d87a6238b4301a6"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1d/08/3b8d8f1b4ec212c17429c2f3ff55b7f2237a1ad0c954972e39c8f0ac394c/paramiko-2.11.0.tar.gz"
    sha256 "003e6bee7c034c21fbb051bf83dc0a9ee4106204dd3c53054c71452cc4ec3938"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/88/87/72eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587e/pyasn1-modules-0.2.8.tar.gz"
    sha256 "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/13/6e/916cdf94f9b38ae0777b254c75c3bdddee49a54cc4014aac1460a7a172b3/pydot-1.4.2.tar.gz"
    sha256 "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-vagrant" do
    url "https://files.pythonhosted.org/packages/2b/3f/2e42a44c9705d72d9925fe8daf00f31bcf82e8b84ec5a752a8a1357c3ef8/python-vagrant-1.0.0.tar.gz"
    sha256 "a8fe93ccf2ff37ecc95ec2f49ea74a91a6ce73a4db4a16a98dd26d397cfd09e5"
  end

  resource "qrcode" do
    url "https://files.pythonhosted.org/packages/94/9f/31f33cdf3cf8f98e64c42582fb82f39ca718264df61957f28b0bbb09b134/qrcode-7.3.1.tar.gz"
    sha256 "375a6ff240ca9bd41adc070428b5dfc1dcfbb0f2507f1ac848f6cded38956578"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/8b/25/08e5ad2431a028d0723ca5540b3af6a32f58f25e83c6dda4d0fcef7288a3/ruamel.yaml.clib-0.2.6.tar.gz"
    sha256 "4ff604ce439abb20794f05613c374759ce10e3595d1867764dd1ae675b85acbd"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c0/6c/9f840c2e55b67b90745af06a540964b73589256cb10cc10057c87ac78fc2/wheel-0.37.1.tar.gz"
    sha256 "e9a504e793efbca1b8e0e9cb979a249cf4a0a7b5b8c9e8b65a5e39d49529c1c4"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")

    venv.pip_install resource("lxml")
    venv.pip_install resource("cffi") # or bcrypt fails to build
    venv.pip_install resource("wheel") # or kiwisolver fails to build

    res = resources.map(&:name).to_set - %w[cffi lxml ptyprocess wheel]

    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
    bash_completion.install "completion/bash-completion" => "fdroid"
    doc.install "examples"

    site_packages = Language::Python.site_packages("python3.10")
    %w[fonttools ipython pygments yamllint].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end
  end

  def caveats
    <<~EOS
      In order to function, fdroidserver requires that the Android SDK's
      "Build-tools" and "Platform-tools" are installed.  Also, it is best if the
      base path of the Android SDK is set in the standard environment variable
      ANDROID_HOME.  To install them from the command line, run:
      android update sdk --no-ui --all --filter tools,platform-tools,build-tools-25.0.0
    EOS
  end

  test do
    # locales aren't set correctly within the testing environment
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"

    # fdroid prefers to work in a dir called 'fdroid'
    mkdir testpath/"fdroid" do
      mkdir "repo"
      mkdir "metadata"

      (testpath/"fdroid/config.py").write "gradle = 'gradle'"
      (testpath/"fdroid/metadata/fake.yml").write <<~EOS
        Categories:
          - Internet
        License: GPL-3.0-or-later

        Summary: Yup still fake
        Description: this is fake

        AutoUpdateMode: None
        UpdateCheckMode: None
      EOS

      system bin/"fdroid", "checkupdates", "--verbose", "--allow-dirty"
      system bin/"fdroid", "lint", "--verbose"
      system bin/"fdroid", "rewritemeta", "fake", "--verbose"
      system bin/"fdroid", "scanner", "--verbose"
    end
  end
end
