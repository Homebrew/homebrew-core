class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https://github.com/elceef/dnstwist"
  url "https://files.pythonhosted.org/packages/e7/0e/88b4c5c7f3077c0d2e8544a14e321fce80b3cf0148a46dec9724e27c61d3/dnstwist-20250130.tar.gz"
  sha256 "8b6dd9c42a643a0e8b087903c0e6d75c0f6cebf94920ab0b7760ac2522c6bb42"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba65fc29b292f09a04c23ff18b6f22b0c71c73a396be342478d006cee91cadfb"
    sha256 cellar: :any,                 arm64_sequoia: "92a414114759163636ead9e95b31239a977ceae1eeb477696f2d21ac144c23d7"
    sha256 cellar: :any,                 arm64_sonoma:  "30209cc6e33da07ba4518aa25e9218445f4668b72542a776ad086788c8fca62c"
    sha256 cellar: :any,                 arm64_ventura: "d2116f01b9fa5ea57456d7828632315f1de22842aa31ca88fb10c1820663fc06"
    sha256 cellar: :any,                 sonoma:        "efbac42648b10f833375d9356c7b2563c7567d005efd00ada0434a7a3d9a9812"
    sha256 cellar: :any,                 ventura:       "699a8d6af729a1aa6fe1786b2d996b0c8611dd5d8f9812b2d1b330947a4e3cb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbb111e74bbc82d05bc1b4b9effd33eba19e1672f077565d94b226cc4015eb94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d2b855062d208f7ea5b2b4799b33cdc4d661e955ab7bd83ae0b5acffe1e5b4b"
  end

  depends_on "certifi"
  depends_on "libmaxminddb"
  depends_on "python@3.13"
  depends_on "ssdeep"

  uses_from_macos "libffi"

  on_linux do
    depends_on "whois"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/e6/0b/e39ad954107ebf213a2325038a3e7a506be3d98e1435e1f82086eec4cde2/aiohttp-3.12.14.tar.gz"
    sha256 "6e06e120e34d93100de448fd941522e11dafa78ef1a893c179901b7d66aa29f2"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/79/b1/b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6/frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "geoip2" do
    url "https://files.pythonhosted.org/packages/0f/5f/902835f485d1c423aca9097a0e91925d6a706049f64e678ec781b168734d/geoip2-5.1.0.tar.gz"
    sha256 "ee3f87f0ce9325eb6484fe18cbd9771a03d0a2bad1dd156fa3584fafa562d39a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "maxminddb" do
    url "https://files.pythonhosted.org/packages/d1/10/7a7cf5219b74b19ea1834b43256e114564e8a845f447446ac821e1b9951e/maxminddb-2.7.0.tar.gz"
    sha256 "23a715ed3b3aed07adae4beeed06c51fd582137b5ae13d3c6e5ca4890f70ebbf"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/3d/2c/5dad12e82fbdf7470f29bff2171484bf07cb3b16ada60a6589af8f376440/multidict-6.6.3.tar.gz"
    sha256 "798a9eb12dab0a6c2e29c1de6f3468af5cb2da6053a20dfa3344907eed0937cc"
  end

  resource "ppdeep" do
    url "https://files.pythonhosted.org/packages/f2/74/d328ee495bcf5f98ae2967fdce45e1ca4b73e8f253e24a61e50f7527d5d9/ppdeep-20250625.tar.gz"
    sha256 "b7da50e54ed9bd79326382b6f2f51f371816f0495a5233dee23a9469f87a2a78"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a6/16/43264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776/propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "py-tlsh" do
    url "https://files.pythonhosted.org/packages/ba/5b/4d860cffd3e6e7afb277e159d97e11583fc3b611d22355799364dff325f1/py-tlsh-4.7.2.tar.gz"
    sha256 "5b6943cfd93a168671f33b84828dca34d252278bdedcacf25cbe711fda655e9f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/df/a1/5723b07a70c1841a80afc9ac572fdf53488306848d844cd70519391b0d26/tld-0.13.1.tar.gz"
    sha256 "75ec00936cbcf564f67361c41713363440b6c4ef0f0c1592b5b0fbe72c17a350"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/3c/fb/efaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963/yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  def install
    ENV["MAXMINDDB_USE_SYSTEM_LIBMAXMINDDB"] = "1"
    ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi" if OS.mac?

    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources

    (libexec/"bin").install "dnstwist.py" => "dnstwist"
    (bin/"dnstwist").write_env_script libexec/"bin/dnstwist", PATH: "#{libexec}/bin:$PATH"
  end

  test do
    output = shell_output("#{bin}/dnstwist --registered --lsh ssdeep brew.sh 2>&1")

    assert_match "brew.sh", output
    assert_match "NS:ns1.dnsimple.com", output
  end
end
