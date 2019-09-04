class Mitmproxy < Formula
  include Language::Python::Virtualenv

  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "https://mitmproxy.org"
  url "https://github.com/mitmproxy/mitmproxy/archive/v4.0.4.tar.gz"
  sha256 "d91eaaad06a5e124a76388999b22a4c590ea26149a30aaff73658cd98d0651d5"
  revision 1
  head "https://github.com/mitmproxy/mitmproxy.git"

  bottle do
    cellar :any
    sha256 "3e1277a4acd877102431ea1ccfc9e6dde9f31e5f143c5dc235dc7db38e8b57d7" => :mojave
    sha256 "4b67c15ba802ed833e66f0cb958f0839265891feb7220a4d0d2ffb323274dfdf" => :high_sierra
    sha256 "515144fbe7cf65730be7819f1d2e1bbffc9237727833d8357ea267fceaee5b59" => :sierra
    sha256 "4f970bf7dfb95e5322a15423c1e8f706ab2a4f1e1f0f3966b1a8d5b204df8b3a" => :el_capitan
  end

  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "python"

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
    url "https://files.pythonhosted.org/packages/79/a2/61c8625f96c8582d3053f89368c483ba62e56233d055e58e372f94a393f0/cryptography-2.3.tar.gz"
    sha256 "c132bab45d4bd0fff1d3fe294d92b0a6eb8404e93337b3127bdec9f21de117e6"
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
    url "https://files.pythonhosted.org/packages/10/46/059775dc8e50f722d205452bced4b3cc965d27e8c3389156acd3b1123ae3/pyasn1-0.4.4.tar.gz"
    sha256 "f58f2a3d12fd754aa123e9fa74fb7345333000a035f3921dbdaa08597aa53137"
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
    url "https://files.pythonhosted.org/packages/2d/9a/23059a00dfd52eb700bd03c4ee3a6954cae60827539c3488026c8742a555/pyperclip-1.6.4.tar.gz"
    sha256 "f70e83d27c445795b6bf98c2bc826bbf2d0d63d4c7f83091c8064439042ba0dc"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/3d/46/a08f44a2a919e32689dca849ebfcb4f71f5e91e18f840bd49a88dc157a14/ruamel.yaml-0.15.46.tar.gz"
    sha256 "8f048085a58ca59353c2c283e5f14af387ab6a1a7ae5d6ec26056bc2e7a396f0"
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
    url "https://files.pythonhosted.org/packages/45/ec/f2a03a0509bcfca336bef23a3dab0d07504893af34fd13064059ba4a0503/tornado-5.1.tar.gz"
    sha256 "4f66a2172cb947387193ca4c2c3e19131f1c70fa8be470ddbbd9317fd0801582"
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
    venv.pip_install resource("cffi")
    venv.pip_install resources
    venv.pip_install_and_link buildpath
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/mitmproxy --version 2>&1")
  end
end
