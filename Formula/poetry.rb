class Poetry < Formula
  include Language::Python::Virtualenv

  desc "Python package management tool"
  homepage "https://python-poetry.org/"
  url "https://files.pythonhosted.org/packages/d6/75/2603419dcfafb3e777b304c9cb2813a8a4090db04356b750a662663c3c01/poetry-1.2.0.tar.gz"
  sha256 "17c527d5d5505a5a7c5c14348d87f077d643cf1f186321530cde68e530bba59f"
  license "MIT"
  head "https://github.com/python-poetry/poetry.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "078f4d06ca1d5115bedbae198d2be3a473e55f37ff18db2d9a035779bf11544c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8e32ded2bead695a726d9bb7f94a6f701e1082be4182f34b32873757464bc51"
    sha256 cellar: :any_skip_relocation, monterey:       "5b75c0c8caaa151fec3b9e774c14d2e51715ce653c5bf108c49e3fe074a85827"
    sha256 cellar: :any_skip_relocation, big_sur:        "822ca5ef064bb96352f6984705b254c8d98fd66fd5fe0ff1b22ce9cb0735e52d"
    sha256 cellar: :any_skip_relocation, catalina:       "441c1c9f100c0f1e38cdcda394159a374aedd88b0364e948a7c27b5dd5b7d101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "766107054184a893989b0f0d8899e3b25d56d4e772cfbaca8966e31dcaf02361"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "CacheControl" do
    url "https://files.pythonhosted.org/packages/46/9b/34215200b0c2b2229d7be45c1436ca0e8cad3b10de42cfea96983bd70248/CacheControl-0.12.11.tar.gz"
    sha256 "a5b9fcc986b184db101aa280b42ecdcdfc524892596f606858e0b7a8b4d9e144"
  end

  resource "cachy" do
    url "https://files.pythonhosted.org/packages/a0/0c/45b249b0efce50a430b8810ec34c5f338d853c31c24b0b297597fd28edda/cachy-0.3.0.tar.gz"
    sha256 "186581f4ceb42a0bbe040c407da73c14092379b1e4c0e327fdb72ae4a9b269b1"
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

  resource "cleo" do
    url "https://files.pythonhosted.org/packages/2f/16/1c1902b225756745f9860451a44a2e2a3c26ee91c72295e83c63df605ed1/cleo-1.0.0a5.tar.gz"
    sha256 "097c9d0e0332fd53cc89fc11eb0a6ba0309e6a3933c08f7b38558555486925d3"
  end

  resource "crashtest" do
    url "https://files.pythonhosted.org/packages/08/3c/5ec13020a4693fab34e1f438fe6e96aed6551740e1f4a5cc66e8b84491ea/crashtest-0.3.1.tar.gz"
    sha256 "42ca7b6ce88b6c7433e2ce47ea884e91ec93104a4b754998be498a8e6c3d37dd"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/8e/99/7f139ec0e9d224542115ef070c79503bcb271edaaf0c1e049a5fbdaad6a5/dulwich-0.20.45.tar.gz"
    sha256 "70710dd9ca2a442190c7e506892db074c318ac762e221f7529b8ce34802041b7"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/35/ee/889aee424a43066a06ac68e499335877775eac9b4409f7860f6af94c6688/jsonschema-4.14.0.tar.gz"
    sha256 "15062f4cc6f591400cd528d2c355f2cfa6a57e44c820dc783aee5e23d36a831f"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/a7/d8/ca70a209ea09e97e4d9feba2f6b38b4eaf918de15a7ada3f3a2246c26cf9/keyring-23.8.2.tar.gz"
    sha256 "0d9973f8891850f1ade5f26aafd06bb16865fbbae3fc56b0defb6a14a2624003"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/00/91/fe0806e3ebded8c4e52f93ab4d963eef34bb33595c7aa7b5591d32ab5b92/pkginfo-1.8.3.tar.gz"
    sha256 "a84da4318dd86f870a9447a8c98340aa06216bfc6f2b7bdc4b8766984ae1867c"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/ea/47/929cccb98445b627e3a42f29290b3f6dc6c21f3dc0ba7b3bf16215298f94/poetry-core-1.1.0.tar.gz"
    sha256 "d145ae121cf79118a8901b60f2c951c4edcc16f55eb8aaefc156aa33aa921f07"
  end

  resource "poetry-plugin-export" do
    url "https://files.pythonhosted.org/packages/7a/58/040a58ad48814a3fd22d0ca78967deb4be72fdd0e2990085379a70a8fe1d/poetry-plugin-export-1.0.6.tar.gz"
    sha256 "af870afceb38e583afa57bcfadfa5cd35ebd74e35aacadcb802bb3a073c13adb"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pylev" do
    url "https://files.pythonhosted.org/packages/11/f2/404d2bfa30fb4ee7c7a7435d593f9f698b25d191cafec69dd0c726f02f11/pylev-1.4.0.tar.gz"
    sha256 "9e77e941042ad3a4cc305dcdf2b2dec1aec2fbe3dd9015d2698ad02b173006d1"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/42/ac/455fdc7294acc4d4154b904e80d964cc9aae75b087bbf486be04df9f2abd/pyrsistent-0.18.1.tar.gz"
    sha256 "d4d61f8b993a7255ba714df3aca52700f8125289f84f704cf80916517c46eb96"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/bd/e6/fdf53ebbf08016dba98f2b047d4db95790157f0e2eed3b14bb5754271475/shellingham-1.5.0.tar.gz"
    sha256 "72fb7f5c63103ca2cb91b23dee0c71fe8ad6fbfd46418ef17dbe40db51592dad"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/84/51/092a8b945edc3b93f2de091ab9596006673caac063e3fac14f0fa6c69b1c/tomlkit-0.11.4.tar.gz"
    sha256 "3235a9010fae54323e727c3ac06fb720752fe6635b3426e379daec60fbd44a83"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/62/2d/06980235e155c7ee1971f77439cbbc3069e98de49540e89f2291905eb4a8/virtualenv-20.16.4.tar.gz"
    sha256 "014f766e4134d0008dcaa1f95bafa0fb0f575795d07cae50b1bee514185d6782"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/91/ac/5898d1811abc88c3710317243168feff61ce12be220b9c92ee045ecd66c4/xattr-0.9.9.tar.gz"
    sha256 "09cb7e1efb3aa1b4991d6be4eb25b73dc518b4fe894f0915f5b0dcede972f346"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/poetry", "completions")
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    # The poetry add command would fail in CI when keyring is enabled
    ENV["PYTHON_KEYRING_BACKEND"] = "keyring.backends.null.Keyring"

    assert_match version.to_s, shell_output("#{bin}/poetry --version")
    assert_match "Created package", shell_output("#{bin}/poetry new homebrew")

    cd testpath/"homebrew" do
      system bin/"poetry", "config", "virtualenvs.in-project", "true"
      system bin/"poetry", "add", "requests"
      system bin/"poetry", "add", "boto3"
    end

    assert_predicate testpath/"homebrew/pyproject.toml", :exist?
    assert_predicate testpath/"homebrew/poetry.lock", :exist?
    assert_match "requests", (testpath/"homebrew/pyproject.toml").read
    assert_match "boto3", (testpath/"homebrew/pyproject.toml").read
  end
end
