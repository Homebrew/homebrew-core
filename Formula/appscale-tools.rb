class AppscaleTools < Formula
  desc "Command-line tools for working with AppScale"
  homepage "https://github.com/AppScale/appscale-tools"
  url "https://github.com/AppScale/appscale-tools/archive/3.8.1.tar.gz"
  sha256 "9e3ff5e205d53ffc8da5c0a2fcee1b45e37505cef8409aadc474561f57589778"
  head "https://github.com/AppScale/appscale-tools.git"

  bottle do
    cellar :any
    sha256 "dc2f20c3743a21aa5f06b3068faadf0f00c5da34728ca55af936439213b9f7ad" => :catalina
    sha256 "eb5e13b06c11ecb6a29eb79e0bcd474ee8320c5ce4d223427809b03f899aebbf" => :mojave
    sha256 "70e89498336894ae025118e51e418528d8d73da9b1e2786559b6bcbe6055f55b" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "ssh-copy-id"
  # Uses SOAPPy, which does not support Python 3
  uses_from_macos "python@2" # does not support Python 3

  resource "appscale-agents" do
    url "https://files.pythonhosted.org/packages/ae/98/c03c30e991b4ff6729937578b33ce2c54e9272384a134e09615449d8182f/appscale-agents-3.8.1.tar.gz"
    sha256 "a6a962e3e1caa852a7b9855778b0df4ee6804a112a5fb08f073bf611c9c91f59"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/20/59/fc5d08966bbd13c5f5d647c8fdc9af5c62b998420652c3349584c0f80676/configparser-3.5.1.tar.gz"
    sha256 "f41e19cb29bebfccb1a78627b3f328ec198cc8f39510c7c55e7dfc0ab58c8c62"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c/entrypoints-0.3.tar.gz"
    sha256 "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/94/d8/65c86584e7e97ef824a1845c72bbe95d79f5b306364fa778a3c3e401b309/pathlib2-2.3.5.tar.gz"
    sha256 "6cd9a47b597b37cc57de1c05e56fb1a1c9cc9fab04fe78c29acd090418529868"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/44/ef/beae4b4ef80902f22e3af073397f079c96969c69b2c7d52a57ea9ae61c9d/retrying-1.3.3.tar.gz"
    sha256 "08c039560a6da2fe4f2c426d0766e284d3b736e355f8dd24b37367b0bb41973b"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/67/b0/b2ea2bd67bfb80ea5d12a5baa1d12bda002cab3b6c9b48f7708cd40c34bf/typing-3.7.4.1.tar.gz"
    sha256 "91dfe6f3f706ee8cc32d38edbbf304e9b7583fb37108fef38229617f8b3eba23"
  end

  resource "SOAPpy" do
    url "https://files.pythonhosted.org/packages/78/1b/29cbe26b2b98804d65e934925ced9810883bdda9eacba3f993ad60bfe271/SOAPpy-0.12.22.zip"
    sha256 "e70845906bb625144ae6a8df4534d66d84431ff8e21835d7b401ec6d8eb447a5"
  end

  # Dependencies for SOAPpy
  resource "docutils" do
    url "https://files.pythonhosted.org/packages/93/22/953e071b589b0b1fee420ab06a0d15e5aa0c7470eb9966d60393ce58ad61/docutils-0.15.2.tar.gz"
    sha256 "a2aeea129088da402665e92e0b25b04b073c04b2dce4ab65caaa38b7ce2e1a99"
  end

  # pinned to 0.4.3 version
  resource "wstools" do
    url "https://files.pythonhosted.org/packages/81/a3/0fbea78bccec0970032b847135b0d6050224c8601460464edcc748c5a22c/wstools-0.4.3.tar.gz"
    sha256 "578b53e98bc8dadf5a55dfd1f559fd9b37a594609f1883f23e8646d2d30336f8"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/a4/5f/f8aa58ca0cf01cbcee728abc9d88bfeb74e95e6cb4334cfd5bed5673ea77/defusedxml-0.6.0.tar.gz"
    sha256 "f684034d135af4c6cbb949b8a4d2ed61634515257a67299e5f940fbaa34377f5"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/8d/c9/e5be955a117a1ac548cdd31e37e8fd7b02ce987f9655f5c7563c656d5dcb/PyYAML-5.2.tar.gz"
    sha256 "c0ee8eca2c582d29c3c2ec6e2c4f703d1b7f1fb10bc72317355a746057e7346c"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  # pinned at 1.5.4 version
  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/31/c4/c77f3ddadf17d041f237615d5fba02faefd93adfb82ad75877156647491a/google-api-python-client-1.5.4.tar.gz"
    sha256 "b9f6697cf9d2d556e8241c18518f1f9a2531e71b59703d0d1505bb47e97009ac"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/cd/db/f7b98cdc3f81513fb25d3cbe2501d621882ee81150b745cdd1363278c10a/uritemplate-3.0.0.tar.gz"
    sha256 "c02643cebe23fc8adb5e6becffe201185bf06c40bda5c0b4028a93f1527d011d"
  end

  # Dependencies for google-api-python-client
  # pinned at 4.0.0 version
  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/c2/ce/7aaf19d8b856191e2e1885201fe45f3dc57b97f5ec5bc98ef2cc15472918/oauth2client-4.0.0.tar.gz"
    sha256 "80be5420889694634b8517b4acd3292ace881d9d1aa9d590d37ec52faec238c7"
  end

  # Dependencies for oauth2client
  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/75/93/c51104ea6a74252957c341ccd110b65efecc18edfd386b666637d67d4d10/pyasn1-modules-0.2.7.tar.gz"
    sha256 "0c35a52e00b672f832e5846826f1fb7507907f7d52fba6faa9e3c4cbe874fe4b"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/cb/d0/8f99b91432a60ca4b1cd478fd0bdf28c1901c58e3a9f14f4ba3dba86b57f/rsa-4.0.tar.gz"
    sha256 "1a836406405730121ae9823e19c6e806c62bbad73f890574fff50efa4122c487"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/ce/2e/87461bfbb7e561203b759b3f7f639e2144226604372830d00a8279960ae1/httplib2-0.14.0.tar.gz"
    sha256 "34537dcdd5e0f2386d29e0e2c6d4a1703a3b982d34c198a5102e6e5d6194b107"
  end

  # pinned at 0.7.7 version
  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/1c/a1/3367581782ce79b727954f7aa5d29e6a439dc2490a9ac0e7ea0a7115435d/tabulate-0.7.7.tar.gz"
    sha256 "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/dc/8c/7c9869454bdc53e72fb87ace63eac39336879eef6f2bf96e946edbf03e90/setuptools-33.1.1.zip"
    sha256 "6b20352ed60ba08c43b3611bdb502286f7a869fbfcf472f40d7279f1e77de145"
  end

  # Dependencies for Azure
  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/15/00/8bfe15183eadaecd8d7a53db58b1a4a085ed509630757423ece1649716bd/azure-datalake-store-0.0.48.tar.gz"
    sha256 "d27c335783d4add00b3a5f709341e4a8009857440209e15a739a9a96b52386f7"
  end

  resource "azure-graphrbac" do
    url "https://files.pythonhosted.org/packages/fe/43/e961f80fa6ec54d2b7e650d63673ede04a0641776318f6aa6d243ce5faa3/azure-graphrbac-0.30.0.zip"
    sha256 "90c6886a601da21d79cb38f956b2354f7806ca06ead27937928c1b513d842b87"
  end

  resource "azure-keyvault" do
    url "https://files.pythonhosted.org/packages/82/8b/9761cf4a00d9a9bdaf58507f21fce6ea5ea13236165afc0a0c19a74ac497/azure-keyvault-0.3.3.zip"
    sha256 "7f748c111e8e246aa3c50dc36a1245cd2c33885665795e09fd7a926e4fd4af85"
  end

  resource "azure-mgmt" do
    url "https://files.pythonhosted.org/packages/8e/31/e64ee90f2666e06d655f7baf80719c95f856dd3f40bba30ecb58960db54f/azure-mgmt-1.0.0.zip"
    sha256 "1c02c18eec90bfccfabfb685862b91810d639f0517afb133c60a0d23972c797c"
  end

  resource "azure-mgmt-marketplaceordering" do
    url "https://files.pythonhosted.org/packages/e9/90/1bf9d50614acee60ba5447bc9db6d63930f1559182fa8266ccac60a96dd3/azure-mgmt-marketplaceordering-0.2.1.zip"
    sha256 "dc765cde7ec03efe456438c85c6207c2f77775a8ce8a7adb19b0df5c5dc513c2"
  end

  resource "azure-mgmt-nspkg" do
    url "https://files.pythonhosted.org/packages/c4/d4/a9a140ee15abd8b0a542c0d31b7212acf173582c10323b09380c79a1178b/azure-mgmt-nspkg-3.0.2.zip"
    sha256 "8b2287f671529505b296005e6de9150b074344c2c7d1c805b3f053d081d58c52"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/16/8d/b6bd5b542ff116318bfb31f5a63f3882f4560763ade4336d69dd3d7c59b9/azure-mgmt-sql-0.5.3.zip"
    sha256 "75fe9ca8bc259ffff61494dafaf12e700687f95f7695792fd2978111634bc562"
  end

  resource "azure-mgmt-trafficmanager" do
    url "https://files.pythonhosted.org/packages/c7/0d/ae54b4c47fc5079344f5494f24428dfaf3e385d426c96588de0065f19095/azure-mgmt-trafficmanager-0.30.0.zip"
    sha256 "92361dd3675e93cb9a11494a53853ec2bdf3aad09b790f7ce02003d0ca5abccd"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/94/dc/28167c592722316a94f8814610048faaf25cbde5935bb8fb568e142ca613/azure-mgmt-web-0.32.0.zip"
    sha256 "f5992c32c1fda3085dcc2276a034f95dbe7dadc36a35c61f5326c8009f3f1866"
  end

  resource "azure-nspkg" do
    url "https://files.pythonhosted.org/packages/39/31/b24f494eca22e0389ac2e81b1b734453f187b69c95f039aa202f6f798b84/azure-nspkg-3.0.2.zip"
    sha256 "e7d3cea6af63e667d87ba1ca4f8cd7cb4dfca678e4c55fc1cedb320760e39dd0"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/e4/c9/0300b5a409a3758c0b6f77df5d8816366c9516579d065210ef3a2f21e23a/azure-common-1.1.23.zip"
    sha256 "53b1195b8f20943ccc0e71a17849258f7781bc6db1c72edc7d6c055f79bd54e3"
  end

  resource "azure-servicemanagement-legacy" do
    url "https://files.pythonhosted.org/packages/7e/9e/ad8c5e8b2715736df200c0d1baf63d38044d9113145d86c4d53923a81919/azure-servicemanagement-legacy-0.20.6.zip"
    sha256 "c883ff8fa3d4f4cb7b9344e8cb7d92a9feca2aa5efd596237aeea89e5c10981d"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/47/04/5fc6c74ad114032cd2c544c575bffc17582295e9cd6a851d6026ab4b2c00/futures-3.3.0.tar.gz"
    sha256 "7e033af76a5e35f58e56da7a91e687706faf4e7bdfb2cbc3f2cca6b9bcda9794"
  end

  resource "azure-storage" do
    url "https://files.pythonhosted.org/packages/5f/63/94f7c7f89a7d28b0141b3fda6ccaad75d4bc8341eabbaa6caa0602c953f8/azure-storage-0.34.2.zip"
    sha256 "f840a878780ead8f236070ef4f09fa9f9040fc4fa6bdf0e3d5a59c4af89ca4d7"
  end

  resource "azure-servicebus" do
    url "https://files.pythonhosted.org/packages/82/29/cb0cfd5cc8b7b92b1a67c2fbab55e72792080255498cab7a2bbfe50ce90a/azure-servicebus-0.21.1.zip"
    sha256 "bb6a27afc8f1ea9ab46ff2371069243d45000d351d9b64e450b63d52409b934d"
  end

  resource "azure-servicefabric" do
    url "https://files.pythonhosted.org/packages/3e/6d/0485c26434d27d367987f5c2adfcf056a1e67d41a7d52efad31369d61536/azure-servicefabric-5.6.130.zip"
    sha256 "7d4731e7513861c6a8bd3e672810ee7c88e758474d15030981c9196df74829d7"
  end

  resource "azure-batch" do
    url "https://files.pythonhosted.org/packages/de/39/df035b541fb8fca8c79825ee2a25347c2803fc0ab55a84f44ce5d06ee324/azure-batch-3.0.0.zip"
    sha256 "c089979dc8579b5a738578f60df82928269608e95cf7ef2a7433a1f27c54bdaf"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/42/17/e61abf2dcdc5c89a589a061165c75209e33f89582445a5ea3ce29cdc5c8f/azure-mgmt-storage-1.0.0.zip"
    sha256 "a4382efd0e5c223b8002c0aa799a2c4c901bce44f6927379d6801deb0b1e6d1e"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/70/6e/3ad7eb0195cd49e54c906c5e32d0ebbdf487c579eab929d27a9c589f2f9d/azure-mgmt-resource-7.0.0.zip"
    sha256 "eaea8b5d05495d1b74220052275d46b6bed93b59245bcaa747279a52e41c3bdf"
  end

  resource "azure-mgmt-batch" do
    url "https://files.pythonhosted.org/packages/7b/e5/4457999b46dc09512e7920c0f527838afc464f20afee4ea2b4cedf66e25a/azure-mgmt-batch-7.0.0.zip"
    sha256 "16c5b652b439b1a0a20366558f5c06858a3052d50b16a470bb80cd30f97abca1"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/29/f9/ab33d99f9d6474a61d80477099f2033661d04c7cd143e4d62a648c482b7b/azure-mgmt-compute-10.0.0.zip"
    sha256 "cfdf35722d5d7ccee8d32a81f6734b210298dfaed10f7299efadf06ea7e96be8"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/b4/d3/e8bd01c5914825a44cc4144187312c70923abc8154f5938318e759befb99/azure-mgmt-keyvault-2.0.0.zip"
    sha256 "4ad6294a19c97db05b754ec2308083f53cbd7a1219d0651dcc277b044989f114"
  end

  resource "azure-mgmt-logic" do
    url "https://files.pythonhosted.org/packages/20/1d/857b2356bfd4990cbabfb4995833df4c0328ccf8abf593dc2df0278ffeea/azure-mgmt-logic-3.0.0.zip"
    sha256 "d163dfc32e3cfa84f3f8131a75d9e94f5c4595907332cc001e45bf7e4efd5add"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/97/28/6cb33ab8c36044241c708815e56b398171df214336064449abe946b22569/azure-mgmt-network-8.0.0.zip"
    sha256 "3bcaf24d962e7a5282b9ae65828e97266721e4746ed76fac5e49b5a7c2222fdf"
  end

  resource "azure-mgmt-scheduler" do
    url "https://files.pythonhosted.org/packages/d5/aa/7da465221d39a51af660322c10d8b0b11df243d28e3f866c603ae815b07d/azure-mgmt-scheduler-1.1.2.zip"
    sha256 "792d9548ae947b83acc4155a40c02f27f2d8d07ffafa0aac26ecda18d75b2903"
  end

  resource "azure-mgmt-redis" do
    url "https://files.pythonhosted.org/packages/d0/d2/5f42ae10ee738da5cfaffa082fdd1ef07e1ccd546d72953f87f15f878e57/azure-mgmt-redis-6.0.0.zip"
    sha256 "db999e104edeee3a13a8ceb1881e15196fe03a02635e0e20855eb52c1e2ecca1"
  end

  resource "azure-mgmt" do
    url "https://files.pythonhosted.org/packages/b3/2d/800b26d5a1b3650c8a96161793be08687e75976ec8df91027afd2f31ab55/azure-mgmt-4.0.0.zip"
    sha256 "8dcbee7b323c3898ae92f5e2d88c3e6201f197ae48a712970929c4646cc2580a"
  end

  resource "azure" do
    url "https://files.pythonhosted.org/packages/a5/ee/b754502a20b9d35a2b35646c0ad06ae2aa1551783658f460bad3841ce9fb/azure-2.0.0.zip"
    sha256 "9d9010483e26275543c12025a7b8bf41b226d4b0c2ce3faeed6b17ec1c7ae3a1"
  end

  # Dependencies for cryptography
  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2d/bf/960e5a422db3ac1a5e612cb35ca436c3fc985ed4b7ed13a1b4879006f450/cffi-1.13.2.tar.gz"
    sha256 "599a1e8ff057ac530c9ad1778293c665cb81a791421f46922d80a86473c13346"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/b9/9a/3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9/ipaddress-1.0.23.tar.gz"
    sha256 "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/c1/a9/86bfedaf41ca590747b4c9075bc470d0b2ec44fb5db5d378bc61447b3b6b/asn1crypto-1.2.0.tar.gz"
    sha256 "87620880a477123e01177a1f73d0f327210b43a3cdbd714efcd2fa49a8d7b384"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/be/60/da377e1bed002716fb2d5d1d1cab720f298cb33ecff7bf7adea72788e4e4/cryptography-2.8.tar.gz"
    sha256 "3cda1f0ed8747339bbdf71b9f38ca74c7b592f24f65cdb3ab3765e4b02871651"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/e5/1d/64a3b1c30842ecf0518af93ed123e5064559e588aebdcae0a59831dee642/python-dateutil-2.7.0.tar.gz"
    sha256 "8f95bb7e6edbb2456a51a1fb58c8dca942024b4f5844cae62c90aa88afe6e300"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/2f/38/ff37a24c0243c5f45f5798bd120c0f873eeed073994133c084e1cf13b95c/PyJWT-1.7.1.tar.gz"
    sha256 "8d59a976fb773f3e6a39c85636357c4f0e242707394cadadd9814f5cbaa20e96"
  end

  resource "adal" do
    url "https://files.pythonhosted.org/packages/75/e2/c44b5e8d99544a2e21aace5f8390c6f3dbf8a952f0453779075ffafafc80/adal-1.2.2.tar.gz"
    sha256 "5a7f1e037c6290c6d7609cab33a9e5e988c2fbec5c51d1c4c649ee3faff37eaf"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0d/1d/6cc4bd4e79f78be6640fab268555a11af48474fac9df187c3361a1d1d2f0/pyOpenSSL-19.1.0.tar.gz"
    sha256 "9a24494b2602aaf402be5c9e30a0b82d4a5c67528fe8fb475e3f3bc00dd69507"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ad/fc/54d62fa4fc6e675678f9519e677dfc29b8964278d75333cf142892caf015/urllib3-1.25.7.tar.gz"
    sha256 "f3c5fd51747d450d4dcf6f923c81f78f811aab8205fda64b0aba34a4e48b0745"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/53/3c/418da48e76dd6ec171b6ad086bc6216d3c0eae13fcec96861fe83128f016/keyring-12.0.2.tar.gz"
    sha256 "445d9521b4fcf900e51c075112e25ddcf8af1db7d1d717380b64eda2cda84abc"
  end

  resource "keyrings.alt" do
    url "https://files.pythonhosted.org/packages/3d/94/5953839c03457054707cc72466af7728c0588ca0398d7cab3af40c624393/keyrings.alt-3.1.tar.gz"
    sha256 "b59c86b67b9027a86e841a49efc41025bcc3b1b0308629617b66b7011e52db5a"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/cd/ce/1381822930cb2e90e889e43831428982577acb9caec5244bcce1c9c542f9/msrestazure-0.4.34.tar.gz"
    sha256 "4fc94a03ecd5b094ab904d929cc5be7a6a80262eab93948260cfe9081a9e6de4"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fc/c7/829c73c64d3749da7811c06319458e47f3461944da9d98bb4df1cb1598c2/oauthlib-3.1.0.tar.gz"
    sha256 "bee41cc35fcca6e988463cacc3bcb8a96224f470ca547e697b604cc697b2f889"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/23/eb/68fc8fa86e0f5789832f275c8289257d8dc44dbe93fce7ff819112b9df8f/requests-oauthlib-1.3.0.tar.gz"
    sha256 "b4261601a71fd721a8bd6d7aa1cc1d6a8a93b4a9f5e96626f8e4d91e8beeaa6a"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/08/5d/e22f815bc27ae7f9ae9eb22c0cd35f103ac481aa7d0cf644b7ea10f368f3/msrest-0.6.10.tar.gz"
    sha256 "f5153bfe60ee757725816aedaa0772cbfe0bddb52cd2d6db4cb8b4c3c6c6f928"
  end

  resource "haikunator" do
    url "https://files.pythonhosted.org/packages/af/58/6a000ee0ec34cac5c78669359a8b1db969f1f511454a140ad3d193714ba2/haikunator-2.1.0.zip"
    sha256 "91ee3949a3a613cac037ddde0b16b17062e248376b11491436e49d5ddc75ff9b"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    site_packages = libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", site_packages
    system "python", *Language::Python.setup_install_args(libexec)

    # appscale is a namespace package
    touch site_packages/"appscale/__init__.py"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"appscale", "help"
    system bin/"appscale", "init", "cloud"
  end
end
