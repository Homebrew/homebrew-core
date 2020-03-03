class Poetry < Formula
  include Language::Python::Virtualenv

  desc "Python package management tool"
  homepage "https://python-poetry.org/"
  url "https://files.pythonhosted.org/packages/2c/79/7fc6e1ac5ebff02e39f24a17ddf56ef6370797a8371e6cfc5c7b56d3a1ea/poetry-1.0.5.tar.gz"
  sha256 "8e195ea8a4bce4f418a23fd828aa2f9ce06be7655720efd1d95beb0ee641030a"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d98261dfde4e086b5ed1f100fc20a8b39fee57081e6da83d3671feb275c0481" => :catalina
    sha256 "42967228661abe70625b5e0af526e709db85de16439ecd8f2861a84c44021520" => :mojave
    sha256 "8ce2ac8630626710d9917fa18698ea0d44a5b2cce8f6ea46dc0774943ea8f0d2" => :high_sierra
  end

  depends_on "python"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"
    sha256 "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"
  end

  resource "CacheControl" do
    url "https://files.pythonhosted.org/packages/44/b9/9a1d4349824ae14de4052e84802a0c372fff1fd2bd6668f7e9efe91ac11d/CacheControl-0.12.6.tar.gz"
    sha256 "be9aa45477a134aee56c8fac518627e1154df063e85f67d4f83ce0ccc23688e8"
  end

  resource "cachy" do
    url "https://files.pythonhosted.org/packages/a0/0c/45b249b0efce50a430b8810ec34c5f338d853c31c24b0b297597fd28edda/cachy-0.3.0.tar.gz"
    sha256 "186581f4ceb42a0bbe040c407da73c14092379b1e4c0e327fdb72ae4a9b269b1"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cleo" do
    url "https://files.pythonhosted.org/packages/99/d5/409b11936085c97ea7c9f596b7fcc3aac0cd9243bbba64be914bb9142bc2/cleo-0.7.6.tar.gz"
    sha256 "99cf342406f3499cec43270fcfaf93c126c5164092eca201dfef0f623360b409"
  end

  resource "clikit" do
    url "https://files.pythonhosted.org/packages/17/c1/72bb34dcb120d32850543389e8d40b5bacba447152832569ba081113f003/clikit-0.4.2.tar.gz"
    sha256 "f67336462800078e0896cf6ecfa3b460dfea4dfa01de659388a4ff0d83c8d6ca"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/85/3e/cf449cf1b5004e87510b9368e7a5f1acd8831c2d6691edd3c62a0823f98f/html5lib-1.0.1.tar.gz"
    sha256 "66cb0dcfdbbc4f9c3ba1a63fdb511ffdbd4f513b2b6d81b80cd26ce6b3fb3736"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  # importlib-metadata<1.2.0,>=1.1.3
  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/e0/ab/591e1162057d42954114d87cd73ee29f7259535f3743f6618fc09ce681a9/importlib_metadata-1.1.3.tar.gz"
    sha256 "7a99fb4084ffe6dae374961ba7a6521b79c1d07c658ab3a28aa264ee1d1b14e3"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  # keyring<21.0.0,>=20.0.1
  resource "keyring" do
    url "https://files.pythonhosted.org/packages/97/b5/983b219cc9288340b1a572dc85b1efd96938d807dae9ebc9355616e0db32/keyring-20.0.1.tar.gz"
    sha256 "963bfa7f090269d30bdc5e25589e5fd9dad2cf2a7c6f176a7f2386910e5d0d8d"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/a0/47/6ff6d07d84c67e3462c50fa33bf649cda859a8773b53dc73842e84455c05/more-itertools-8.2.0.tar.gz"
    sha256 "b1ddb932186d8a6ac451e1d95844b382f55e12686d51ca0c68b6f61f2ab7a507"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/e4/4f/057549afbd12fdd5d9aae9df19a6773a3d91988afe7be45b277e8cee2f4d/msgpack-1.0.0.tar.gz"
    sha256 "9534d5cc480d4aff720233411a1f765be90885750b07df772380b34c10ecb5c0"
  end

  resource "pastel" do
    url "https://files.pythonhosted.org/packages/c9/c8/aa23c18b1b811b1907f06b1556d39213982675dd2a2e72493d20fe2b6a57/pastel-0.2.0.tar.gz"
    sha256 "46155fc523bdd4efcd450bbcb3f2b94a6e3b25edc0eb493e081104ad09e1ca36"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/6c/04/fd6683d24581894be8b25bc8c68ac7a0a73bf0c4d74b888ac5fe9a28e77f/pkginfo-1.5.0.1.tar.gz"
    sha256 "7424f2c8511c186cd5424bbf31045b77435b37a8d604990b79d4e70d741148bb"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/7d/2d/e4b8733cf79b7309d84c9081a4ab558c89d8c89da5961bf4ddb050ca1ce0/ptyprocess-0.6.0.tar.gz"
    sha256 "923f299cc5ad920c68f2bc0bc98b75b9f838b93b599941a6b63ddbc2476394c0"
  end

  resource "pylev" do
    url "https://files.pythonhosted.org/packages/cc/61/dab2081d3d86dcf0b9f5dcfb11b256d76cd14aad7ccdd7c8dd5e7f7e41a0/pylev-1.3.0.tar.gz"
    sha256 "063910098161199b81e453025653ec53556c1be7165a9b7c50be2f4d57eae1c3"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/a2/56/0404c03c83cfcca229071d3c921d7d79ed385060bbe969fde3fd8f774ebd/pyparsing-2.4.6.tar.gz"
    sha256 "4c830582a84fb022400b85429791bc551f1f4871c33f23e44f353119e92f969f"
  end

  # pyrsistent<0.15.0,>=0.14.2
  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/8c/46/4e93ab8a379d7efe93f20a0fb8a27bdfe88942cc954ab0210c3164e783e0/pyrsistent-0.14.11.tar.gz"
    sha256 "3ca82748918eb65e2d89f222b702277099aca77e34843c5eb9d52451173970e2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  # requests-toolbelt<0.9.0,>=0.8.0
  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/86/f9/e80fa23edca6c554f1994040064760c12b51daff54b55f9e379e899cd3d4/requests-toolbelt-0.8.0.tar.gz"
    sha256 "f6a531936c6fa4c6cfce1b9c10d5c4f498d16528d2a54a22ca00011205a187b5"
  end

  # sdist for 1.3.2 has no setup.py file
  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/1b/82/52b4facd501d1cdfee1f2b3aa6092dc0ee6c07baf78692f9035adb1357da/shellingham-1.3.1.tar.gz"
    sha256 "985b23bbd1feae47ca6a6365eacd314d93d95a8a16f8f346945074c28fe6f3e0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/53/10/1f1186fcd453d10254450a7e947e92e6dbb0bf1418484aa4da2829be44f9/tomlkit-0.5.11.tar.gz"
    sha256 "f044eda25647882e5ef22b43a1688fb6ab12af2fc50e8456cdfc751c873101cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/09/06/3bc5b100fe7e878d3dee8f807a4febff1a40c213d2783e3246edde1f3419/urllib3-1.25.8.tar.gz"
    sha256 "87716c2d2a7121198ebcb7ce7cccf6ce5e9ba539041cfbaeecfb641dc0bf6acc"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/78/08/d52f0ea643bc1068d6dc98b412f4966a9b63255d20911a23ac3220c033c4/zipp-1.2.0.tar.gz"
    sha256 "c70410551488251b0fee67b460fb9a536af8d6f9f008ad10ac51f615b6a521b1"
  end

  def install
    xy = Language::Python.major_minor_version "python3"

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install libexec/"bin/poetry"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_match version.to_s, shell_output("#{bin}/poetry --version")
    assert_match "Created package", shell_output("#{bin}/poetry new homebrew")

    cd testpath/"homebrew" do
      system "#{bin}/poetry", "config", "virtualenvs.in-project", "true"
      system "#{bin}/poetry", "add", "requests"
      system "#{bin}/poetry", "add", "boto3"
    end

    assert_predicate testpath/"homebrew/pyproject.toml", :exist?
    assert_predicate testpath/"homebrew/poetry.lock", :exist?
    assert_match "requests", (testpath/"homebrew/pyproject.toml").read
    assert_match "boto3", (testpath/"homebrew/pyproject.toml").read
  end
end
