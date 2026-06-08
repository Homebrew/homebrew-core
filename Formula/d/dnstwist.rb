class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https://github.com/elceef/dnstwist"
  url "https://files.pythonhosted.org/packages/e7/0e/88b4c5c7f3077c0d2e8544a14e321fce80b3cf0148a46dec9724e27c61d3/dnstwist-20250130.tar.gz"
  sha256 "8b6dd9c42a643a0e8b087903c0e6d75c0f6cebf94920ab0b7760ac2522c6bb42"
  license "Apache-2.0"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c903f6252938a08e58c36212dfbe26133bf67189e219e0d0cc1adebc309a16f8"
    sha256 cellar: :any,                 arm64_sequoia: "0625ac02fa65990d0ce851b64e83c04ee6f2cf9f0d8755db03f68a4afb34668d"
    sha256 cellar: :any,                 arm64_sonoma:  "7030946843964f2b86a725aac53738502ef0cbac1da7d5028bb32c46d34ded40"
    sha256 cellar: :any,                 sonoma:        "4d06cd950d86de39d1ca2a49177f94c6c74b799817383bee57ce940fcd96206a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b77faf649090c18b1ed949fd93ae81faedf2482a58fbbf9b2789703f5f8641c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8eaba8d8ebae2b345d6a6f697bfa4aa678d6196f90bd0dfbf1abe3d0fca3581"
  end

  depends_on "rust" => :build # for geoip2, uv-backend
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
    url "https://files.pythonhosted.org/packages/77/9a/152096d4808df8e4268befa55fba462f440f14beab85e8ad9bf990516918/aiohttp-3.13.5.tar.gz"
    sha256 "9d98cc980ecc96be6eb4c1994ce35d28d8b1f5e5208a23b421187d1209dbb7d1"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
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
    url "https://files.pythonhosted.org/packages/18/70/3d9e87289f79713aaf0fea9df4aa8e68776640fe59beb6299bb214610cfd/geoip2-5.2.0.tar.gz"
    sha256 "6c9ded1953f8eb16043ed0a8ea20e6e9524ea7b65eb745724e12490aca44ef00"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "maxminddb" do
    url "https://files.pythonhosted.org/packages/31/83/bcd7f2e7dfcf601258a4eab92155816218e8f8adf6608d5f7d39da7ba863/maxminddb-3.1.1.tar.gz"
    sha256 "b19a938c481518f19a2c534ffdcb3bc59582f0fbbdcf9f81ac9adf912a0af686"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "ppdeep" do
    url "https://files.pythonhosted.org/packages/ef/6c/4b97c7c1f7dcb4ee0c8d3534284e7f1a638dee6dccd5d0a8f7d9fa6dac3c/ppdeep-20260221.tar.gz"
    sha256 "8be1f4164b7ad2f7c40a51a664d3176701e40b2f9c1b96d18eeffaf06dfeff94"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "py-tlsh" do
    url "https://files.pythonhosted.org/packages/d4/fb/a1aceafcf0c5196f1cb558319dca5231190f248f27fbec2e4033276db77f/py_tlsh-5.0.0.tar.gz"
    sha256 "a21cb75eb49e9d9237c8c39d2fb310a5c976b3abc6c35c2e405e16c089abad1b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/5c/5d/76b4383ac4e5b5e254e50c09807b3e13820bed6d6c11cd540264988d6802/tld-0.13.2.tar.gz"
    sha256 "d983fa92b9d717400742fca844e29d5e18271079c7bcfabf66d01b39b4a14345"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/79/12/1e8f37460ea0f7eb59c221fdaf0ed75e7ac43e97f8093b9c6f411df50a78/yarl-1.24.2.tar.gz"
    sha256 "9ac374123c6fd7abf64d1fec93962b0bd4ee2c19751755a762a72dd96c0378f8"
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
    assert_match "NS:ns1.dnsimple-edge.com", output
  end
end
