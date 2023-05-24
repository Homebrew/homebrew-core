class OnlykeyAgent < Formula
  include Language::Python::Virtualenv

  desc "Middleware that lets you use OnlyKey as a hardware SSH/GPG device"
  homepage "https://docs.crp.to/onlykey-agent.html"
  url "https://files.pythonhosted.org/packages/02/c1/27c6cfbc5ee63fca91e37915d0182c0bfb988ca12362f01bcd5451e0ee10/onlykey-agent-1.1.14.tar.gz"
  sha256 "096f20580ae112f57c1b9b279ed17728dc8e6f0fca301be586b9d976177f1523"
  license "LGPL-3.0-only"
  revision 1

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_ventura:  "9b631682be9dad2d61d3b5ccfbf93dc27cc6ee79b4655ed0ba4b12b2c33b24b0"
    sha256 cellar: :any,                 arm64_monterey: "1ed4a49fb373a8f79e49321bdf90c8b3dc75e496b6cf0e29c955b2c03b19155d"
    sha256 cellar: :any,                 arm64_big_sur:  "2ddf251cd336f2dd7bafa6f69b74f59527b85ca4d652209e51689504ef9e294f"
    sha256 cellar: :any,                 ventura:        "555508e6b5d2edec05e9f310d6b9d9d57ade813eef8ae5eaa6865bd9978e91f9"
    sha256 cellar: :any,                 monterey:       "3b23f9477adad5f24027ad127e9c213cf1464a1502de55e87a0c53242098ab3c"
    sha256 cellar: :any,                 big_sur:        "92e6c78e7283b1894ec7de44696020c0c181e804686b2ac6b82a956c81bb8359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5598d8d272755bdb2a089fae8a7a037021eba17db1054e3d0838ea2fcaf9a96f"
  end

  # `pkg-config`, `rust`, and `openssl@1.1` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "cffi"
  depends_on "gnupg"
  depends_on "hidapi"
  depends_on "libcython"
  depends_on "libusb"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python@3.11"
  depends_on "six"

  resource "aenum" do
    url "https://files.pythonhosted.org/packages/95/52/2e14cc189a4fde1e6e7f8f9039f3818f4be86fa772a2397235f01ed4ba1c/aenum-3.1.12.tar.gz"
    sha256 "3e531c91860a81f885f7e6e97d219ae9772cb899580084788935dad7d9742ef0"
  end

  resource "backports-shutil-which" do
    url "https://files.pythonhosted.org/packages/a0/22/51b896a4539f1bff6a7ab8514eb031b9f43f12bff23f75a4c3f4e9a666e5/backports.shutil_which-3.5.2.tar.gz"
    sha256 "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133"
  end

  resource "bech32" do
    url "https://files.pythonhosted.org/packages/ab/fe/b67ac9b123e25a3c1b8fc3f3c92648804516ab44215adb165284e024c43f/bech32-1.2.0.tar.gz"
    sha256 "7d6db8214603bd7871fcfa6c0826ef68b85b0abd90fa21c285a9c5e21d2bd899"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f7/80/04cc7637238b78f8e7354900817135c5a23cf66dfb3f3a216c6d630d6833/cryptography-40.0.2.tar.gz"
    sha256 "c33c0d32b8594fa647d2e01dbccc303478e16fdd7cf98652d5b3ed11aa5e5c99"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/1f/53/a5da4f2c5739cf66290fac1431ee52aff6851c7c8ffd8264f13affd7bcdd/docutils-0.20.1.tar.gz"
    sha256 "f08a4e276c3a1583a86dce3e34aba3fe04d02bba2dd51ed16106244e8a923e3b"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/74/6e/58e1bb40a284291ab483d00831c5b91fe14d498a3ae7c658f3c588658e4b/fido2-0.9.3.tar.gz"
    sha256 "b45e89a6109cfcb7f1bb513776aa2d6408e95c4822f83a253918b944083466ec"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/78/0a/d71f35a8dcbe88dab21cd668a62b688ea6dd45872feba45a97efd0452c19/hidapi-0.13.1.tar.gz"
    sha256 "99b18b28ec414ef9b604ddaed08182e486a400486f31ca56f61d537eed1d17cf"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "intelhex" do
    url "https://files.pythonhosted.org/packages/66/37/1e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01/intelhex-2.3.0.tar.gz"
    sha256 "892b7361a719f4945237da8ccf754e9513db32f5628852785aea108dcd250093"
  end

  resource "lib-agent" do
    url "https://files.pythonhosted.org/packages/3c/0b/d084adec9efa8170b200e2a98d311e5703b3986a6bb049d871402dfc9607/lib-agent-1.0.5.tar.gz"
    sha256 "63d281afb997d3fe5b660dbff998f015b8e40bffee24855063008ab8e7f4deff"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mnemonic" do
    url "https://files.pythonhosted.org/packages/f8/8d/d4dc2b2bddfeb57cab4404a41749b577f578f71140ab754da9afa8f5c599/mnemonic-0.20.tar.gz"
    sha256 "7c6fb5639d779388027a77944680aee4870f0fcd09b1e42a5525ee2ce4c625f6"
  end

  resource "onlykey" do
    url "https://files.pythonhosted.org/packages/95/27/5bf7048f6d9de97610b6252b392a6d2d7e929dcd82809b973aebf1727114/onlykey-1.2.10.tar.gz"
    sha256 "666427c99c7d625208c4c31d674536cdbf9000d7dcc2bb46ee24752e98339814"
  end

  resource "onlykey-solo-python" do
    url "https://files.pythonhosted.org/packages/f5/aa/da868b3a695ed2de3ffd71455a8269e031fd478957e888028480f7331c6b/onlykey-solo-python-0.0.32.tar.gz"
    sha256 "f3c0ee8605f8142c3320acf0e11a9680cb6345d7f986e5652841c00049a29ee4"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/4b/bb/75cdcd356f57d17b295aba121494c2333d26bfff1a837e6199b8b83c415a/prompt_toolkit-3.0.38.tar.gz"
    sha256 "23ac5d50538a9a38c8bde05fecb47d0b403ecd0662857a86f886f798563d5b9b"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/05/0e7547c445bbbc96c538d870e6c5c5a69a9fa5df0a9df3e27cb126527196/pycryptodome-3.18.0.tar.gz"
    sha256 "c9adee653fc882d98956e33ca2c1fb582e23a8af7ac82fee75bd6113c55a0413"
  end

  resource "pymsgbox" do
    url "https://files.pythonhosted.org/packages/7d/ff/4c6f31a4f08979f12a663f2aeb6c8b765d3bd592e66eaaac445f547bb875/PyMsgBox-1.0.9.tar.gz"
    sha256 "2194227de8bff7a3d6da541848705a155dcbb2a06ee120d9f280a1d7f51263ff"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/84/50/97b81327fccbb70eb99f3c95bd05a0c9d7f13fb3f4cfd975885110d1205a/python-daemon-3.0.1.tar.gz"
    sha256 "6c57452372f7eaff40934a1c03ad1826bf5e793558e87fef49131e6464b4dae5"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/d9/6e/433a5614132576289b8643fe598dd5d51b16e130fd591564be952e15bb45/pyusb-1.2.1.tar.gz"
    sha256 "a4cc7404a203144754164b8b40994e2849fde1cfff06b08492f12fff9d9de7b9"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/9f/93/b7389cdd7e573e70cfbeb4b0bbe101af1050a6681342f5d2bc6f1bf2d150/semver-3.0.0.tar.gz"
    sha256 "94df43924c4521ec7d307fc86da1531db6c2c33d9d5cdc3e64cca0eb68569269"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/0b/25/37c77fc07821cd06592df3f18281f5e716bc891abd6822ddb9ff941f821e/Unidecode-1.3.6.tar.gz"
    sha256 "fed09cf0be8cf415b391642c2a5addfc72194407caee4f98719e40ec2a72b830"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fc/ef/0335f7217dd1e8096a9e8383e1d472aa14717878ffe07c4772e68b6e8735/wheel-0.40.0.tar.gz"
    sha256 "cd1196f3faee2b31968d626e1731c94f99cbdb67cf5a46e4f5656cbee7738873"
  end

  def install
    python3 = "python3.11"
    # prevent "fatal error: libusb.h: No such file or directory" when building hidapi on linux
    ENV.append_to_cflags "-I#{Formula["libusb"].include}/libusb-1.0"
    # replacement for virtualenv_install_with_resources per https://docs.brew.sh/Python-for-Formula-Authors
    venv = virtualenv_create(libexec, python3)
    # build hidapi
    resource("hidapi").stage do
      # monkey patch hidapi's include paths to be the homebrew-installed path instead
      # TODO: Fix this with an upstream patch to support `--with-system-hidapi=/foo/bar/hidapi`
      #       per https://github.com/Homebrew/homebrew-core/pull/104096#discussion_r919469723
      inreplace "setup.py" do |s|
        s.gsub! "/usr/include/libusb-1.0", "#{Formula["libusb"].opt_include}/libusb-1.0"
        s.gsub! "/usr/include/hidapi", "#{Formula["hidapi"].opt_include}/hidapi"
      end
      system python3, *Language::Python.setup_install_args(libexec, python3), "--with-system-hidapi"
    end
    # now have pip build other resources except hidapi:
    venv.pip_install resources.reject { |r| r.name == "hidapi" }
    venv.pip_install_and_link buildpath

    # add path configuration file to find cython
    site_packages = Language::Python.site_packages(python3)
    pth_contents = <<~EOS
      import site; site.addsitedir('#{Formula["libcython"].opt_libexec/site_packages}')
    EOS
    (libexec/site_packages/"homebrew-onlykey-agent.pth").write pth_contents
  end

  test do
    # the device mut not be plugged in to get the expected message
    # since CI is the foremost user of `brew test` we assume that there is no device
    output = shell_output("#{bin}/onlykey-agent test@example.com 2>&1", 1)
    assert_match("try unplugging and replugging your device", output)
  end
end
