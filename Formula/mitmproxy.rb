class Mitmproxy < Formula
  include Language::Python::Virtualenv

  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "https://mitmproxy.org"
  url "https://github.com/mitmproxy/mitmproxy/archive/v4.0.3.tar.gz"
  sha256 "e6b6cc33babbe91ab1fe36f6ff1d8a9a8d3dbf966b437eb26e9789eb97dc188f"
  head "https://github.com/mitmproxy/mitmproxy.git"

  bottle do
    cellar :any
    sha256 "0492d4a6e7892536df7022f1a134a3aab6b8563fff1d50be0b01fb6e736ca35d" => :high_sierra
    sha256 "e0d88888e1f97b33aded23186cc398177f832a3dcbc150e9ab4fbbf41fb6b3e1" => :sierra
    sha256 "ba9caec394371c8baefd4dcd845edf2e3d014009257d9dba5b8da7e3333a6477" => :el_capitan
  end

  depends_on "openssl"
  depends_on "python"
  depends_on "protobuf"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1b/51/e2a9f3b757eb802f61dc1f2b09c8c99f6eb01cf06416c0671253536517b6/blinker-1.4.tar.gz"
    sha256 "471aee25f3992bd325afa3772f1063dbdbbca947a041b8b89466dc00d606f8b6"
  end

  resource "brotlipy" do
    url "https://files.pythonhosted.org/packages/d9/91/bc79b88590e4f662bd40a55a2b6beb0f15da4726732efec5aa5a3763d856/brotlipy-0.7.0.tar.gz"
    sha256 "36def0b859beaf21910157b4c33eb3b06d8ce459c942102f16988cca6ea164df"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4d/9c/46e950a6f4d6b4be571ddcae21e7bc846fcbb88f1de3eff0f6dd0a6be55d/certifi-2018.4.16.tar.gz"
    sha256 "13e698f54293db9f89122b0581843a782ad0934a4fe0172d2a980ba77fc61bb7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/b2/faa78c1ab928d2b2c634c8b41ff1181f0abdd9adf9193211bd606ffa57e2/cryptography-2.2.2.tar.gz"
    sha256 "9fc295bf69130a342e7a19a39d7bbeb15c0bcaabc7382ec33ef3b2b7d18d2f63"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/50/13/954a4bd263857262a0b07155b47f5494a02b97984a5bcc6263bf89f12586/h11-0.7.0.zip"
    sha256 "1c0fbb1cba6f809fe3e6b27f8f6d517ca171f848922708871403636143d530d9"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/3c/86/aebb88df3c87255cfd0ffd338608fbfb34d1c850750a486e7f05b013e5a3/h2-3.0.1.tar.gz"
    sha256 "b2962f883fa392a23cbfcc4ad03c335bcc661be0cf9627657b589f0df2206e64"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/44/f1/b4440e46e265a29c0cb7b09b6daec6edf93c79eae713cfed93fbbf8716c5/hpack-3.0.0.tar.gz"
    sha256 "8eec9c1f4bfae3408a3f30500261f7e6a65912dc138526ea054f9ad98892e9d2"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/a4/59/dddaddc73b4d53e9649850998e23b6daca80817c5442465a12423235d20b/hyperframe-5.1.0.tar.gz"
    sha256 "a25944539db36d6a2e47689e7915dcee562b3f8d10c6cdfa0d53c91ed692fb04"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "kaitaistruct" do
    url "https://files.pythonhosted.org/packages/23/71/8577ca06e81c1dc0ba03a39ae32e315175ba2d9df51befa3a45f47950056/kaitaistruct-0.8.tar.gz"
    sha256 "d1d17c7f6839b3d28fc22b21295f787974786c2201e8788975e72e2a1d109ff5"
  end

  resource "ldap3" do
    url "https://files.pythonhosted.org/packages/bf/5b/4848db7aa210a27793d7fc218c7deb588a5f2b23f5359a0537285ee1ee60/ldap3-2.5.tar.gz"
    sha256 "55078bbc981f715a8867b4c040402627fdfccf5664e0277a621416559748e384"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/25/4b/6fbfc66aabb3017cd8c3bd97b37f769d7503ead2899bf76e570eb91270de/passlib-1.7.1.tar.gz"
    sha256 "3d948f64138c25633613f303bcc471126eae67c04d5e3f6b7b8ce6242f8653e0"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/0d/33/3466a3210321a02040e3ab2cd1ffc6f44664301a5d650a7e44be1dc341f2/pyasn1-0.4.3.tar.gz"
    sha256 "fb81622d8f3509f0026b0683fe90fea27be7284d3826a5f2edf97f69151ab0fc"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/9b/7c/ee600b2a9304d260d96044ab5c5e57aa489755b92bbeb4c0803f9504f480/pyOpenSSL-18.0.0.tar.gz"
    sha256 "6488f1423b00f73b7ad5167885312bb0ce410d3312eb212393795b53c8caa580"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/33/15/f3c29b381815ae75e27589583655f4a8567721c541b8ba8cd52f76868655/pyperclip-1.6.2.tar.gz"
    sha256 "43496f0a1f363a5ecfc4cda5eba6a2a3d5056fe6c7ffb9a99fbb1c5a3c7dea05"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/ff/20/78ce49baec9d1fadab9a8ae6a475bec798219f4f308345a444006a3c9e6b/ruamel.yaml-0.15.38.tar.gz"
    sha256 "18f90a4ecbcf74429bacac13a79b8754f3f1e6d595bfdc7d9ed87d92110b23dc"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/94/17/39a70184c2dbdb844db6c58c51cb3c9bc572cc08642646e77f0f1bda143c/sortedcontainers-2.0.4.tar.gz"
    sha256 "607294c6e291a270948420f7ffa1fb3ed47384a4c08db6d1e9c92d08a6981982"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/cf/d1/3be271ae5eba9fb59df63c9891fdc7d8044b999e8ac145994cdbfd2ae66a/tornado-5.0.2.tar.gz"
    sha256 "1b83d5c10550f2653380b4c77331d6f8850f287c4f67d7ce1e1c639d9222fbc7"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/c7/90/415728875c230fafd13d118512bde3184d810d7bf798a631abc05fac09d0/urwid-2.0.1.tar.gz"
    sha256 "644d3e3900867161a2fc9287a9762753d66bd194754679adb26aede559bcccbc"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/8a/8e/65017baa6a398f93866c68054ce797aef1a8b10793c94d8653f70e8ad613/wsproto-0.11.0.tar.gz"
    sha256 "02f214f6bb43cda62a511e2e8f1d5fa4703ed83d376d18d042bd2bbf2e995824"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install_and_link buildpath
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/mitmproxy --version 2>&1")
  end
end
