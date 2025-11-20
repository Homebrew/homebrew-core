class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https://github.com/elceef/dnstwist"
  url "https://files.pythonhosted.org/packages/e7/0e/88b4c5c7f3077c0d2e8544a14e321fce80b3cf0148a46dec9724e27c61d3/dnstwist-20250130.tar.gz"
  sha256 "8b6dd9c42a643a0e8b087903c0e6d75c0f6cebf94920ab0b7760ac2522c6bb42"
  license "Apache-2.0"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b8e7358c9feb5a01746e06a1ce99ec68b728ff5880713fdaf4e459fb5b8d34ab"
    sha256 cellar: :any,                 arm64_sequoia: "e434e4e020cbe9d213b3f1a1b890513fd1e18d31b4176698d6d8cc09b477210a"
    sha256 cellar: :any,                 arm64_sonoma:  "fe0a12ff6fd8742d9bd593475e21d4780a5f97d175e80f127d8565c45d8c602e"
    sha256 cellar: :any,                 sonoma:        "3d3e48c9b30ce39427f90fde8eca68e41c0f6172b49430632c37e49921132009"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bf36ee5516fd98f91b0d3013a5cb23d07a7a5ddf81e89d58ad1089e6ea65679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91ff3e7b404827f44d95ea765a1a9995fcaaaf75ff147fd61066b964bf3f79e7"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libmaxminddb"
  depends_on "python@3.14"
  depends_on "ssdeep"

  uses_from_macos "libffi"

  on_linux do
    depends_on "whois"
  end

  pypi_packages package_name:     "dnstwist[full]",
                exclude_packages: "certifi"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/62/f1/8515650ac3121a9e55c7b217c60e7fae3e0134b5acfe65691781b5356929/aiohttp-3.13.0.tar.gz"
    sha256 "378dbc57dd8cf341ce243f13fa1fa5394d68e2e02c15cd5f28eae35a70ec7f67"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "geoip2" do
    url "https://files.pythonhosted.org/packages/0f/5f/902835f485d1c423aca9097a0e91925d6a706049f64e678ec781b168734d/geoip2-5.1.0.tar.gz"
    sha256 "ee3f87f0ce9325eb6484fe18cbd9771a03d0a2bad1dd156fa3584fafa562d39a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "maxminddb" do
    url "https://files.pythonhosted.org/packages/94/9c/5af549744e7a1e986bddd119c0bbca7f7fa7fb72590b554cb860a0c3acb1/maxminddb-2.8.2.tar.gz"
    sha256 "26a8e536228d8cc28c5b8f574a571a2704befce3b368ceca593a76d56b6590f9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/80/1e/5492c365f222f907de1039b91f922b93fa4f764c713ee858d235495d8f50/multidict-6.7.0.tar.gz"
    sha256 "c6e99d9a65ca282e578dfea819cfa9c0a62b2499d8677392e09feaf305e9e6f5"
  end

  resource "ppdeep" do
    url "https://files.pythonhosted.org/packages/f2/74/d328ee495bcf5f98ae2967fdce45e1ca4b73e8f253e24a61e50f7527d5d9/ppdeep-20250625.tar.gz"
    sha256 "b7da50e54ed9bd79326382b6f2f51f371816f0495a5233dee23a9469f87a2a78"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "py-tlsh" do
    url "https://files.pythonhosted.org/packages/ba/5b/4d860cffd3e6e7afb277e159d97e11583fc3b611d22355799364dff325f1/py-tlsh-4.7.2.tar.gz"
    sha256 "5b6943cfd93a168671f33b84828dca34d252278bdedcacf25cbe711fda655e9f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
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
    url "https://files.pythonhosted.org/packages/57/63/0c6ebca57330cd313f6102b16dd57ffaf3ec4c83403dcb45dbd15c6f3ea1/yarl-1.22.0.tar.gz"
    sha256 "bebf8557577d4401ba8bd9ff33906f1376c877aa78d1fe216ad01b4d6745af71"
  end

  def install
    ENV["MAXMINDDB_USE_SYSTEM_LIBMAXMINDDB"] = "1"
    ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi" if OS.mac?

    venv = virtualenv_create(libexec, "python3.14")
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
