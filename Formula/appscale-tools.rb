class AppscaleTools < Formula
  desc "Command-line tools for working with AppScale"
  homepage "https://github.com/AppScale/appscale-tools"
  url "https://files.pythonhosted.org/packages/57/72/dbb91276c1820ce925fadc37d921e19f03da0b619c7027a13ceac7ed9231/appscale-tools-3.8.1.tar.gz"
  sha256 "277d882b18dcb70603467dd66f2665878347274915bc82dabe975ea6e729dbb0"
  license "Apache-2.0"
  head "https://github.com/AppScale/appscale-tools.git"

  bottle do
    sha256 cellar: :any, big_sur:     "69c1aff6adfd929cdce565af76c67dd20e95bf6be18a2aae4f3c69cb1c498bec"
    sha256 cellar: :any, catalina:    "dc2f20c3743a21aa5f06b3068faadf0f00c5da34728ca55af936439213b9f7ad"
    sha256 cellar: :any, mojave:      "eb5e13b06c11ecb6a29eb79e0bcd474ee8320c5ce4d223427809b03f899aebbf"
    sha256 cellar: :any, high_sierra: "70e89498336894ae025118e51e418528d8d73da9b1e2786559b6bcbe6055f55b"
  end

  depends_on "libyaml"
  depends_on :macos # Due to Python 2 (Uses SOAPPy, which does not support Python 3)
  depends_on "openssl@1.1"

  uses_from_macos "libffi"
  uses_from_macos "ssh-copy-id"

  resource "adal" do
    url "https://files.pythonhosted.org/packages/e5/78/d1790e75667e9b659d4ba7a69910f4eade3e7dfd8015ef743d610b06c46b/adal-1.2.6.tar.gz"
    sha256 "08b94d30676ceb78df31bce9dd0f05f1bc2b6172e44c437cbf5b968a00ac6489"
  end

  resource "appscale-agents" do
    url "https://files.pythonhosted.org/packages/ae/98/c03c30e991b4ff6729937578b33ce2c54e9272384a134e09615449d8182f/appscale-agents-3.8.1.tar.gz"
    sha256 "a6a962e3e1caa852a7b9855778b0df4ee6804a112a5fb08f073bf611c9c91f59"
  end

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "azure" do
    url "https://files.pythonhosted.org/packages/a5/ee/b754502a20b9d35a2b35646c0ad06ae2aa1551783658f460bad3841ce9fb/azure-2.0.0.zip"
    sha256 "9d9010483e26275543c12025a7b8bf41b226d4b0c2ce3faeed6b17ec1c7ae3a1"
  end

  resource "azure-batch" do
    url "https://files.pythonhosted.org/packages/de/39/df035b541fb8fca8c79825ee2a25347c2803fc0ab55a84f44ce5d06ee324/azure-batch-3.0.0.zip"
    sha256 "c089979dc8579b5a738578f60df82928269608e95cf7ef2a7433a1f27c54bdaf"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/af/63/bbdc87fd69c7582130f61523cd9e30b7194eae7609d0d168041edc85479e/azure-common-1.1.26.zip"
    sha256 "b2866238aea5d7492cfb0282fc8b8d5f6d06fb433872345864d45753c10b6e4f"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/4b/ed/84aa9faebaee51907405c9da4b54c86ab9c1e48ffb9fa3934507bd3871d2/azure-core-1.11.0.zip"
    sha256 "0e65d50c05bb2a50d90da2c2a2983a5d1e1730cee0584d51e806d9e259955e20"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/2e/e8/0483d88c6dba818b5a81c410c7bf1bce5817077961f3d408731aa2481fa6/azure-datalake-store-0.0.51.tar.gz"
    sha256 "b871ebb3bcfd292e8a062dbbaacbc132793d98f1b60f549a8c3b672619603fc1"
  end

  resource "azure-graphrbac" do
    url "https://files.pythonhosted.org/packages/fe/43/e961f80fa6ec54d2b7e650d63673ede04a0641776318f6aa6d243ce5faa3/azure-graphrbac-0.30.0.zip"
    sha256 "90c6886a601da21d79cb38f956b2354f7806ca06ead27937928c1b513d842b87"
  end

  resource "azure-keyvault" do
    url "https://files.pythonhosted.org/packages/10/92/24d4371d566f447e2b4ecebb9c360ca52e80f0a3381504974b0e37d865e7/azure-keyvault-0.3.7.zip"
    sha256 "549fafb04e1a3af1fdc94ccde05d59180d637ff6485784f716e7ddb30e6dd0ff"
  end

  resource "azure-mgmt" do
    url "https://files.pythonhosted.org/packages/8e/31/e64ee90f2666e06d655f7baf80719c95f856dd3f40bba30ecb58960db54f/azure-mgmt-1.0.0.zip"
    sha256 "1c02c18eec90bfccfabfb685862b91810d639f0517afb133c60a0d23972c797c"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/27/ed/e857a8d638fe605c24ca11fe776edad2b0ff697e2395fff25db254b37dfb/azure-mgmt-authorization-0.30.0.zip"
    sha256 "ff965fe74916974a51e834615b7204f494a1bad42ad8d43874bd879855554466"
  end

  resource "azure-mgmt-batch" do
    url "https://files.pythonhosted.org/packages/a6/d1/dfe06960634579289612aa24162b3fc053af966f886d96d414e4c4cf6e26/azure-mgmt-batch-4.0.0.zip"
    sha256 "a0ca8500724736f6a5789ae671f38006924b95985a82507d73fcb10c1230defb"
  end

  resource "azure-mgmt-cdn" do
    url "https://files.pythonhosted.org/packages/06/aa/c2fdd6dc428b5ea19c326c8af301f02401b93a0fe4650b9083a8c15daa15/azure-mgmt-cdn-0.30.3.zip"
    sha256 "bcf7b058e367608e81c060d17e3ad8f4da91746a9ab87c8ad4054028f3623490"
  end

  resource "azure-mgmt-cognitiveservices" do
    url "https://files.pythonhosted.org/packages/2d/98/998cc11d25751c3fc93078040c9f725641d34d3424dd9cada2b7edf585e4/azure-mgmt-cognitiveservices-1.0.0.zip"
    sha256 "9a124d5c8827c2af3eeb1e3829e116d0ae582d27eb0e49d6a250489b7be11582"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/3d/8e/6f756e94bb84f70e3023846a4bced79aa0d5e287316ba506a9bbb1be101b/azure-mgmt-compute-1.0.0.zip"
    sha256 "04e0795e68555a62ec36510bbe8806caf99a9ead57ae7a04c42ae84e4576459e"
  end

  resource "azure-mgmt-containerregistry" do
    url "https://files.pythonhosted.org/packages/f7/1d/afd8d828f2a4a541daeb44ab4441d02877bdb047494df21e7cf774d37e08/azure-mgmt-containerregistry-0.2.1.zip"
    sha256 "8536e5cb6e24e4713ec27a6285716230795b8995335ada019c794da3c4394980"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/fc/f5/ed6e7dacd1140699bcc74f519d8461dc06425adbaf97629098fef58255ae/azure-mgmt-core-1.2.2.zip"
    sha256 "4246810996107f72482a9351cf918d380c257e90942144ec9c0c2abda1d0a312"
  end

  resource "azure-mgmt-datalake-analytics" do
    url "https://files.pythonhosted.org/packages/3c/e4/dc69239e3a7923e34d7f1bbff7fbccd1ee6ff3fb729603b15a4b9e185a1a/azure-mgmt-datalake-analytics-0.1.6.zip"
    sha256 "acde5be6e04a8717cb3683715195047e05df1b7736b720bce23dc8ebd3e828e0"
  end

  resource "azure-mgmt-datalake-nspkg" do
    url "https://files.pythonhosted.org/packages/8e/0c/7b705f7c4a41bfeb0b6f3557f227c71aa3fa71555ed76ae934aa7db4b13e/azure-mgmt-datalake-nspkg-3.0.1.zip"
    sha256 "deb192ba422f8b3ec272ce4e88736796f216f28ea5b03f28331d784b7a3f4880"
  end

  resource "azure-mgmt-datalake-store" do
    url "https://files.pythonhosted.org/packages/30/e9/615eee9ded7cc0da053a5fd19268ce54b32a8bee4933aee125872c0f515b/azure-mgmt-datalake-store-0.1.6.zip"
    sha256 "ff13e525a534903e0234398f7ffcebead89600933329a78d248877f5f28238b4"
  end

  resource "azure-mgmt-devtestlabs" do
    url "https://files.pythonhosted.org/packages/66/9e/7c8e4b5a09548af7ea8a37add50a0d9e4fd0f69a97b0870c889c684677cf/azure-mgmt-devtestlabs-2.0.0.zip"
    sha256 "3c17adbea354f681a899974a20db340c5197572ccce5aa1d01d1c1c629c8a0b5"
  end

  resource "azure-mgmt-dns" do
    url "https://files.pythonhosted.org/packages/bf/48/260638ac825e36b5e9c3ba92e3aa79160131cca161cceeaac71ec169028d/azure-mgmt-dns-1.0.1.zip"
    sha256 "93e874b83c0c97111fc140fd1f5e7bfa24cee86234b5b36a639b3ccaa1d406b2"
  end

  resource "azure-mgmt-documentdb" do
    url "https://files.pythonhosted.org/packages/20/45/acf459fd3435055fba6a81192f99ad4300b1c6ab256350f0d7540f5b9658/azure-mgmt-documentdb-0.1.3.zip"
    sha256 "8592869f53f16a01d4bcdeb8d862c5929d97eb3f33892c13a66eb7b8342c4906"
  end

  resource "azure-mgmt-iothub" do
    url "https://files.pythonhosted.org/packages/28/83/ec3d8d9825f5084a8808ba0fa0c1e99e345855c8293b43e41020d6848a04/azure-mgmt-iothub-0.2.2.zip"
    sha256 "d6ffdd4a416c51ea83b55f1b5984ebfd3714c019c7c238974119d54092a7cd1a"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/8c/28/04a4eab4f1ec30aff8bc68a6bd525a6a7e9fd2408701cea40708724207bf/azure-mgmt-keyvault-0.31.0.zip"
    sha256 "954e3b9ec064bb0f4f539f8d1a45fd139023b02d1c489d48824017ccb0291ac6"
  end

  resource "azure-mgmt-logic" do
    url "https://files.pythonhosted.org/packages/56/3d/73c27708d003d37f3ad4c5d93978aa14ff00665a5da44eb80100a547863e/azure-mgmt-logic-2.1.0.zip"
    sha256 "a64ced3e50a566f60c8e0fc7c697a3db58a88e62583b2dec0d79f570b8efcdea"
  end

  resource "azure-mgmt-marketplaceordering" do
    url "https://files.pythonhosted.org/packages/44/df/a4fde57510fa68bb2c317b2e257196a1d926d0c84e19c625ad8a4caa5da1/azure-mgmt-marketplaceordering-1.0.0.zip"
    sha256 "85103080f9e59215036bdfb8f806d91ea182d72c46a13f55c3acc479849351e3"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/0f/37/41817796c3887da9f7fa9d565db931cffa1e2d99ecc757cf9127885e6e83/azure-mgmt-monitor-0.2.1.zip"
    sha256 "717b9c57a3c61fbfdba6062b2b307bbd2c2befdea1072b1572ab7a20953168c8"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/a9/b0/67f9338475968ffe024249481b41cc260ae6ba04c0c284ad3aae200b7133/azure-mgmt-network-1.0.0.zip"
    sha256 "8a61b315e83add006d7cbe6ba6a87e2b997a945762ef89736b7a581fa3f0b9d7"
  end

  resource "azure-mgmt-nspkg" do
    url "https://files.pythonhosted.org/packages/c4/d4/a9a140ee15abd8b0a542c0d31b7212acf173582c10323b09380c79a1178b/azure-mgmt-nspkg-3.0.2.zip"
    sha256 "8b2287f671529505b296005e6de9150b074344c2c7d1c805b3f053d081d58c52"
  end

  resource "azure-mgmt-rdbms" do
    url "https://files.pythonhosted.org/packages/4f/bb/fd668496474ca4a43361a83e1db7de41d4f4ff632f74bd446ede9d9f7a2a/azure-mgmt-rdbms-0.1.0.zip"
    sha256 "c06419399f04e2757f447731a09d232090a855369c9f975fc90ed9a8bddd0b01"
  end

  resource "azure-mgmt-redis" do
    url "https://files.pythonhosted.org/packages/e1/1e/cd4958bda1551118f3403728fd6f37547854eba79f7a3bc3e4fefefe9bbb/azure-mgmt-redis-4.1.1.zip"
    sha256 "69fc82efd22337b6ef099967c08d42d05f989ac9b10e57cb24e46786d3f8dcc8"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/e2/2f/d8d54f60f4531b3199d02b512a782aebb70c4065ab4f1e685d066375a10d/azure-mgmt-resource-1.1.0.zip"
    sha256 "5166fede710d906e9a25009d1ee86471d6fd0d7c30e471607e0ea281682d8723"
  end

  resource "azure-mgmt-scheduler" do
    url "https://files.pythonhosted.org/packages/e3/23/b6ac7cbad15b877b371d7b019c4845b8269d96f0c35f22c0afd806bc526b/azure-mgmt-scheduler-1.1.3.zip"
    sha256 "ffd0aa675a7bfc53ce57cf335fcbccf7055b8927413c6b19af3d57d0ac2ce250"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/16/8d/b6bd5b542ff116318bfb31f5a63f3882f4560763ade4336d69dd3d7c59b9/azure-mgmt-sql-0.5.3.zip"
    sha256 "75fe9ca8bc259ffff61494dafaf12e700687f95f7695792fd2978111634bc562"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/42/17/e61abf2dcdc5c89a589a061165c75209e33f89582445a5ea3ce29cdc5c8f/azure-mgmt-storage-1.0.0.zip"
    sha256 "a4382efd0e5c223b8002c0aa799a2c4c901bce44f6927379d6801deb0b1e6d1e"
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

  resource "azure-servicebus" do
    url "https://files.pythonhosted.org/packages/82/29/cb0cfd5cc8b7b92b1a67c2fbab55e72792080255498cab7a2bbfe50ce90a/azure-servicebus-0.21.1.zip"
    sha256 "bb6a27afc8f1ea9ab46ff2371069243d45000d351d9b64e450b63d52409b934d"
  end

  resource "azure-servicefabric" do
    url "https://files.pythonhosted.org/packages/3e/6d/0485c26434d27d367987f5c2adfcf056a1e67d41a7d52efad31369d61536/azure-servicefabric-5.6.130.zip"
    sha256 "7d4731e7513861c6a8bd3e672810ee7c88e758474d15030981c9196df74829d7"
  end

  resource "azure-servicemanagement-legacy" do
    url "https://files.pythonhosted.org/packages/dd/d7/91aaa86ed8bc7aeb5ff7b9bd49d41ea828dd488496bc4c7882a5f86adb76/azure-servicemanagement-legacy-0.20.7.zip"
    sha256 "5d388b9fda83161aca617f224c9e895ce51fe6a84b7524bc000c557c025f91cd"
  end

  resource "azure-storage" do
    url "https://files.pythonhosted.org/packages/42/50/f038b43107a48db27fc016cb604341aa62a3946cee8f3d422075c96cde6e/azure-storage-0.34.3.tar.gz"
    sha256 "46415ba68e78ba10eab5d025e32b5bf9afe5b986060076313e05392409effdb3"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/16/4f/48975536bd488d3a272549eb795ac4a13a5f7fcdc8995def77fbef3532ee/configparser-4.0.2.tar.gz"
    sha256 "c7d282687a5308319bf3d2e7706e575c635b0a470342641c93bea0ea3b5331df"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/d4/85/38715448253404186029c575d559879912eb8a1c5d16ad9f25d35f7c4f4c/cryptography-3.3.2.tar.gz"
    sha256 "5a60d3780149e13b7a6ff7ad6526b38846354d11a15e21068e57073e29e19bed"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/a4/5f/f8aa58ca0cf01cbcee728abc9d88bfeb74e95e6cb4334cfd5bed5673ea77/defusedxml-0.6.0.tar.gz"
    sha256 "f684034d135af4c6cbb949b8a4d2ed61634515257a67299e5f940fbaa34377f5"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c/entrypoints-0.3.tar.gz"
    sha256 "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/11/c4/2da1f4952ba476677a42f25cd32ab8aaf0e1c0d0e00b89822b835c7e654c/enum34-1.1.10.tar.gz"
    sha256 "cce6a7477ed816bd2542d03d53db9f0db935dd013b70f336a95c73979289f248"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/47/04/5fc6c74ad114032cd2c544c575bffc17582295e9cd6a851d6026ab4b2c00/futures-3.3.0.tar.gz"
    sha256 "7e033af76a5e35f58e56da7a91e687706faf4e7bdfb2cbc3f2cca6b9bcda9794"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/31/c4/c77f3ddadf17d041f237615d5fba02faefd93adfb82ad75877156647491a/google-api-python-client-1.5.4.tar.gz"
    sha256 "b9f6697cf9d2d556e8241c18518f1f9a2531e71b59703d0d1505bb47e97009ac"
  end

  resource "haikunator" do
    url "https://files.pythonhosted.org/packages/af/58/6a000ee0ec34cac5c78669359a8b1db969f1f511454a140ad3d193714ba2/haikunator-2.1.0.zip"
    sha256 "91ee3949a3a613cac037ddde0b16b17062e248376b11491436e49d5ddc75ff9b"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/ed/ef/f0e05d5886a9c25dea4b18be06cd7bcaddbae0168cc576f3568f9bd6a35a/httplib2-0.19.0.tar.gz"
    sha256 "e0d428dad43c72dbce7d163b7753ffc7a39c097e6788ef10f4198db69b92f08e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/b9/9a/3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9/ipaddress-1.0.23.tar.gz"
    sha256 "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/5e/4a/d1e3f7284b00d7d59dfa436a773a02cb360378ae6f7f225c587b39cc5d2f/keyring-18.0.1.tar.gz"
    sha256 "67d6cc0132bd77922725fae9f18366bb314fd8f95ff4d323a4df41890a96a838"
  end

  resource "keyrings.alt" do
    url "https://files.pythonhosted.org/packages/62/a4/cfa759dc4a5113d653a1dfdbd61011e88fe7abb7a476c8ca10f37e2a789c/keyrings.alt-3.1.1.tar.gz"
    sha256 "0bc7b75c7e710a3dd7bc4c3841c71467b24ccbce1b85efb2586bdf0c4713f751"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/bb/2c/e8ac4f491efd412d097d42c9eaf79bcaad698ba17ab6572fd756eb6bd8f8/msrest-0.6.21.tar.gz"
    sha256 "72661bc7bedc2dc2040e8f170b6e9ef226ee6d3892e01affd4d26b06474d68d8"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/cd/ce/1381822930cb2e90e889e43831428982577acb9caec5244bcce1c9c542f9/msrestazure-0.4.34.tar.gz"
    sha256 "4fc94a03ecd5b094ab904d929cc5be7a6a80262eab93948260cfe9081a9e6de4"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/c2/ce/7aaf19d8b856191e2e1885201fe45f3dc57b97f5ec5bc98ef2cc15472918/oauth2client-4.0.0.tar.gz"
    sha256 "80be5420889694634b8517b4acd3292ace881d9d1aa9d590d37ec52faec238c7"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fc/c7/829c73c64d3749da7811c06319458e47f3461944da9d98bb4df1cb1598c2/oauthlib-3.1.0.tar.gz"
    sha256 "bee41cc35fcca6e988463cacc3bcb8a96224f470ca547e697b604cc697b2f889"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/94/d8/65c86584e7e97ef824a1845c72bbe95d79f5b306364fa778a3c3e401b309/pathlib2-2.3.5.tar.gz"
    sha256 "6cd9a47b597b37cc57de1c05e56fb1a1c9cc9fab04fe78c29acd090418529868"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/88/87/72eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587e/pyasn1-modules-0.2.8.tar.gz"
    sha256 "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/2f/38/ff37a24c0243c5f45f5798bd120c0f873eeed073994133c084e1cf13b95c/PyJWT-1.7.1.tar.gz"
    sha256 "8d59a976fb773f3e6a39c85636357c4f0e242707394cadadd9814f5cbaa20e96"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/98/cd/cbc9c152daba9b5de6094a185c66f1c6eb91c507f378bb7cad83d623ea88/pyOpenSSL-20.0.1.tar.gz"
    sha256 "4c231c759543ba02560fcd2480c48dcec4dae34c9da7d3747c508227e0624b51"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/23/eb/68fc8fa86e0f5789832f275c8289257d8dc44dbe93fce7ff819112b9df8f/requests-oauthlib-1.3.0.tar.gz"
    sha256 "b4261601a71fd721a8bd6d7aa1cc1d6a8a93b4a9f5e96626f8e4d91e8beeaa6a"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/44/ef/beae4b4ef80902f22e3af073397f079c96969c69b2c7d52a57ea9ae61c9d/retrying-1.3.3.tar.gz"
    sha256 "08c039560a6da2fe4f2c426d0766e284d3b736e355f8dd24b37367b0bb41973b"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/f7/1a/7837a99fbbe0f48c8e0e15d5418fd8981dbda68286a55b9838e218bd085d/rsa-4.5.tar.gz"
    sha256 "4d409f5a7d78530a4a2062574c7bd80311bc3af29b364e293aa9b03eea77714f"
  end

  resource "scandir" do
    url "https://files.pythonhosted.org/packages/df/f5/9c052db7bd54d0cbf1bc0bb6554362bba1012d03e5888950a4f5c5dadc4e/scandir-1.10.0.tar.gz"
    sha256 "4d4631f6062e658e9007ab3149a9b914f3548cb38bfb021c64f39a025ce578ae"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/dc/8c/7c9869454bdc53e72fb87ace63eac39336879eef6f2bf96e946edbf03e90/setuptools-33.1.1.zip"
    sha256 "6b20352ed60ba08c43b3611bdb502286f7a869fbfcf472f40d7279f1e77de145"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "SOAPpy" do
    url "https://files.pythonhosted.org/packages/78/1b/29cbe26b2b98804d65e934925ced9810883bdda9eacba3f993ad60bfe271/SOAPpy-0.12.22.zip"
    sha256 "e70845906bb625144ae6a8df4534d66d84431ff8e21835d7b401ec6d8eb447a5"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/1c/a1/3367581782ce79b727954f7aa5d29e6a439dc2490a9ac0e7ea0a7115435d/tabulate-0.7.7.tar.gz"
    sha256 "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/05/d9/6eebe19d46bd05360c9a9aae822e67a80f9242aabbfc58b641b957546607/typing-3.7.4.3.tar.gz"
    sha256 "1187fb9c82fd670d10aa07bbb6cfcfe4bdda42d6fab8d5134f04e8c4d0b71cc9"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/42/da/fa9aca2d866f932f17703b3b5edb7b17114bb261122b6e535ef0d9f618f8/uritemplate-3.0.1.tar.gz"
    sha256 "5af8ad10cec94f215e3f48112de2022e1d5a37ed427fbd88652fa908f2ab7cae"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d7/8d/7ee68c6b48e1ec8d41198f694ecdc15f7596356f2ff8e6b1420300cf5db3/urllib3-1.26.3.tar.gz"
    sha256 "de3eedaad74a2683334e282005cd8d7f22f4d55fa690a2a1020a416cb0a47e73"
  end

  resource "wstools" do
    url "https://files.pythonhosted.org/packages/81/a3/0fbea78bccec0970032b847135b0d6050224c8601460464edcc748c5a22c/wstools-0.4.3.tar.gz"
    sha256 "578b53e98bc8dadf5a55dfd1f559fd9b37a594609f1883f23e8646d2d30336f8"
  end

  def install
    vendor_site_packages = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", vendor_site_packages
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    site_packages = libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", site_packages
    system "python", *Language::Python.setup_install_args(libexec)

    # python2 doesn't play nicely with packages namespaces
    namespace_import_workaround = <<~EOS
      if __name__ != '__main__':
        try:
          __import__('pkg_resources').declare_namespace(__name__)
        except ImportError:
          __path__ = __import__('pkgutil').extend_path(__path__, __name__)
    EOS
    (vendor_site_packages/"appscale/__init__.py").write namespace_import_workaround
    (site_packages/"appscale/__init__.py").write namespace_import_workaround

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system bin/"appscale", "help"
    system bin/"appscale", "init", "cloud"
  end
end
