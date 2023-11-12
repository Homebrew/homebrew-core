class Offat < Formula
    include Language::Python::Virtualenv
  
    desc "OWASP OFFAT (OFFensive Api Tester) is created to automatically test API for common vulnerabilities after generating tests from openapi specification file. It provides feature to automatically fuzz inputs and use user provided inputs during tests specified via YAML config file."
    homepage "https://owasp.org/OFFAT"
    url "https://files.pythonhosted.org/packages/09/a7/e1df6444ff14b3db8eedc29dd295567e38379f03ac865d5f3f68b97c82b8/offat-0.11.0.tar.gz"
    sha256 "022ac20698d04710502bdba0bbf57bd0206e844c484bc89f1844d9cd37da377b"
  
    depends_on "python3"
  
    resource "aiohttp" do
      url "https://files.pythonhosted.org/packages/fd/01/f180d31923751fd20185c96938994823f00918ee5ac7b058edc005382406/aiohttp-3.8.6.tar.gz"
      sha256 "b0cf2a4501bff9330a8a5248b4ce951851e415bdcce9dc158e76cfd55e15085c"
    end
  
    resource "aiosignal" do
      url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
      sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
    end
  
    resource "async-timeout" do
      url "https://files.pythonhosted.org/packages/87/d6/21b30a550dafea84b1b8eee21b5e23fa16d010ae006011221f33dcd8d7f8/async-timeout-4.0.3.tar.gz"
      sha256 "4640d96be84d82d02ed59ea2b7105a0f7b33abe8703703cd0ab0bf87c427522f"
    end
  
    resource "attrs" do
      url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
      sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
    end
  
    resource "certifi" do
      url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
      sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
    end
  
    resource "chardet" do
      url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
      sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
    end
  
    resource "charset-normalizer" do
      url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
      sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
    end
  
    resource "colorama" do
      url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
      sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
    end
  
    resource "frozenlist" do
      url "https://files.pythonhosted.org/packages/8c/1f/49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22/frozenlist-1.4.0.tar.gz"
      sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
    end
  
    resource "idna" do
      url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
      sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
    end
  
    resource "jsonschema" do
      url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
      sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
    end
  
    resource "jsonschema-spec" do
      url "https://files.pythonhosted.org/packages/a3/d5/b1c6171af26a3086189c45fcc7145cb40cdb7ab6779806e9e321501f5251/jsonschema_spec-0.1.6.tar.gz"
      sha256 "90215863b56e212086641956b20127ccbf6d8a3a38343dad01d6a74d19482f76"
    end
  
    resource "lazy-object-proxy" do
      url "https://files.pythonhosted.org/packages/20/c0/8bab72a73607d186edad50d0168ca85bd2743cfc55560c9d721a94654b20/lazy-object-proxy-1.9.0.tar.gz"
      sha256 "659fb5809fa4629b8a1ac5106f669cfc7bef26fbb389dda53b3e010d1ac4ebae"
    end
  
    resource "multidict" do
      url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
      sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
    end
  
    resource "openapi-schema-validator" do
      url "https://files.pythonhosted.org/packages/f6/bc/ea1c532bba227c61cf57f228790b3544e73fa1f82832bb59f3272672d239/openapi_schema_validator-0.4.4.tar.gz"
      sha256 "c573e2be2c783abae56c5a1486ab716ca96e09d1c3eab56020d1dc680aa57bf8"
    end
  
    resource "openapi-spec-validator" do
      url "https://files.pythonhosted.org/packages/27/e5/9fe67dfd403777d500abb5cd650c16ef9d4918a6c12e87731c3a4feeb4ff/openapi_spec_validator-0.5.7.tar.gz"
      sha256 "6c2d42180045a80fd6314de848b94310bdb0fa4949f4b099578b69f79d9fa5ac"
    end
  
    resource "packaging" do
      url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
      sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
    end
  
    resource "pathable" do
      url "https://files.pythonhosted.org/packages/9d/ed/e0e29300253b61dea3b7ec3a31f5d061d577c2a6fd1e35c5cfd0e6f2cd6d/pathable-0.4.3.tar.gz"
      sha256 "5c869d315be50776cc8a993f3af43e0c60dc01506b399643f919034ebf4cdcab"
    end
  
    resource "prance" do
      url "https://files.pythonhosted.org/packages/73/f0/bcb5ffc8b7ab8e3d02dbef3bd945cf8fd6e12c146774f900659406b9fce1/prance-23.6.21.0.tar.gz"
      sha256 "d8c15f8ac34019751cc4945f866d8d964d7888016d10de3592e339567177cabe"
    end
  
    resource "pyrsistent" do
      url "https://files.pythonhosted.org/packages/ce/3a/5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95ca/pyrsistent-0.20.0.tar.gz"
      sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
    end
  
    resource "PyYAML" do
      url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
      sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
    end
  
    resource "requests" do
      url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
      sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
    end
  
    resource "rfc3339-validator" do
      url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
      sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
    end
  
    resource "ruamel.yaml" do
      url "https://files.pythonhosted.org/packages/82/43/fa976e03a4a9ae406904489119cd7dd4509752ca692b2e0a19491ca1782c/ruamel.yaml-0.18.5.tar.gz"
      sha256 "61917e3a35a569c1133a8f772e1226961bf5a1198bea7e23f06a0841dea1ab0e"
    end
  
    resource "ruamel.yaml.clib" do
      url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
      sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
    end
  
    resource "six" do
      url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
      sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
    end
  
    resource "tabulate" do
      url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
      sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
    end
  
    resource "urllib3" do
      url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
      sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
    end
  
    resource "yarl" do
      url "https://files.pythonhosted.org/packages/5f/3f/04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09/yarl-1.9.2.tar.gz"
      sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
    end
  
    def install
    virtualenv_install_with_resources
    end
  
    test do
      # OFFAT package test script to ensure it's installed correctly
      system bin/"offat", "--version"
    end
  end
