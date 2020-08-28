class Poetry < Formula
  include Language::Python::Virtualenv

  desc "Python package management tool"
  homepage "https://python-poetry.org/"
  url "https://files.pythonhosted.org/packages/8e/f8/ee9590a110aa5f9de86e8de6b6f623f4bd5eb8610b719d21cea5d794fd98/poetry-1.0.10.tar.gz"
  sha256 "4b1b895d272d9bae22e1796dfe38d6122a75963709d7a909068e68aa6937a6f2"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c9d89f1fbb192609392a891f1ad73913f6ad4f2cb641c346c09f1f5a9b31a56e" => :catalina
    sha256 "6e874938bfbe3c44307799d5ef1bcd33221d826d2986d5da1c2b43f06b438c76" => :mojave
    sha256 "6bf073e928676ef54f1fd0d344aef0b8540748eb42e0c05b5def4c87c3dae264" => :high_sierra
  end

  depends_on "python@3.8"

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
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
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
    url "https://files.pythonhosted.org/packages/95/55/c9013126e2468e80a30f3aaec8fdb9b55772f4ab91f79ec8290f6426c60b/clikit-0.4.3.tar.gz"
    sha256 "6e2d7e115e7c7b35bceb0209109935ab2f9ab50910e9ff2293f7fa0b7abf973e"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/97/b5/983b219cc9288340b1a572dc85b1efd96938d807dae9ebc9355616e0db32/keyring-20.0.1.tar.gz"
    sha256 "963bfa7f090269d30bdc5e25589e5fd9dad2cf2a7c6f176a7f2386910e5d0d8d"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
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
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/8c/46/4e93ab8a379d7efe93f20a0fb8a27bdfe88942cc954ab0210c3164e783e0/pyrsistent-0.14.11.tar.gz"
    sha256 "3ca82748918eb65e2d89f222b702277099aca77e34843c5eb9d52451173970e2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

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
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/53/10/1f1186fcd453d10254450a7e947e92e6dbb0bf1418484aa4da2829be44f9/tomlkit-0.5.11.tar.gz"
    sha256 "f044eda25647882e5ef22b43a1688fb6ab12af2fc50e8456cdfc751c873101cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"

    vendor_site_packages = libexec/"vendor/lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", vendor_site_packages
    resources.each do |r|
      r.stage do
        system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    site_packages = libexec/"lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", site_packages
    system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    (bin/"poetry").write <<~PYTHON
      #!#{Formula["python@3.8"].opt_bin/"python3"}
      import sys

      sys.path.insert(0, "#{site_packages}")
      sys.path.insert(0, "#{vendor_site_packages}")

      if __name__ == "__main__":
          from poetry.console import main
          main()
    PYTHON
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"

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
