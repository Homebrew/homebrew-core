class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https://github.com/elceef/dnstwist"
  url "https://github.com/elceef/dnstwist/archive/20201022.tar.gz"
  sha256 "f1a12c013e12e7793562aadbb36577418a7eaea5d93db6d6cd02337f49b8253a"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "77d2df8f14a3a719d80df9c8b6f2d3150aa43b74f7225b43a726353ff4dd6df0" => :catalina
    sha256 "f3c6140dd02d2e5781180f8d995486babdb5f57a919db451f20137053457c625" => :mojave
    sha256 "7106fd748c816e7bfce5c1bdadbb5064b67a957afac396f18c45684163fa323f" => :high_sierra
  end

  depends_on "geoip"
  depends_on "python@3.9"
  depends_on "ssdeep"

  uses_from_macos "libffi"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/f7/09/88bbe20b76ca76be052c366fe77aa5e3cd6e5f932766e5597fecdd95b2a8/cffi-1.14.2.tar.gz"
    sha256 "ae8f34d50af2c2154035984b8b5fc5d9ed63f32fe615646ab435b05b132ca91b"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/67/d0/639a9b5273103a18c5c68a7a9fc02b01cffa3403e72d553acec444f85d5b/dnspython-2.0.0.zip"
    sha256 "044af09374469c3a39eeea1a146e8cac27daec951f1f1f157b1962fc7cb9d1b7"
  end

  resource "GeoIP" do
    url "https://files.pythonhosted.org/packages/f2/7b/a463b7c3df8ef4b9c92906da29ddc9e464d4045f00c475ad31cdb9a97aae/GeoIP-1.3.2.tar.gz"
    sha256 "a890da6a21574050692198f14b07aa4268a01371278dfc24f71cd9bc87ebf0e6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "ssdeep" do
    url "https://files.pythonhosted.org/packages/e0/d3/f17602a7dde1231d332f4067fdd421057ffe335c3bbc295e7ccfab769d95/ssdeep-3.4.tar.gz"
    sha256 "1b5510716bc495a2b18300ea837fcf944552a1cc678bb74e384bce251d99a85f"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/21/ad/ea313baa4f03474b0a212c47da8b92fe52241d4862ad3e29fb025ee2f85f/tld-0.12.2.tar.gz"
    sha256 "cf8410a7ed7b9477f563fa158dabef5117d8374cba55f65142ba0af6dcd15d4d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/81/f4/87467aeb3afc4a6056e1fe86626d259ab97e1213b1dfec14c7cb5f538bf0/urllib3-1.25.10.tar.gz"
    sha256 "91056c15fa70756691db97756772bb1eb9678fa585d9184f24534b100dc60f4a"
  end

  resource "whois" do
    url "https://files.pythonhosted.org/packages/40/f0/d2e038bd54a8c95a4240a322682accd4cb2a1d5f298c40aed9e881d63641/whois-0.9.7.tar.gz"
    sha256 "1e0348c6cc763e1a7c87d32ce877e2531096928e477fdb2e100aa3783e2b4279"
  end

  def install
    ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi"

    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
    venv.pip_install resources

    (libexec/"bin").install "dnstwist.py" => "dnstwist"
    (bin/"dnstwist").write_env_script libexec/"bin/dnstwist", PATH: "#{libexec}/bin:$PATH"
  end

  test do
    output = shell_output("#{bin}/dnstwist -rsw --thread=1 brew.sh")

    assert_match version.to_s, output
    assert_match "Fetching content from:", output
    assert_match "//brew.sh", output
    assert_match /Processing \d+ permutations/, output
    assert_not_match /notice: missing module/, output
  end
end
