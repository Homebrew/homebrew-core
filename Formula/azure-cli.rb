class AzureCli < Formula
  desc "Microsoft Azure CLI 2.0"
  homepage "https://docs.microsoft.com/cli/azure/overview"
  url "https://azurecliprod.blob.core.windows.net/releases/azure-cli_packaged_2.0.19.tar.gz"
  sha256 "122783657ae015ea92f403ef931e841533ccf3751bcd79fc22787ad28c414fd0"
  head "https://github.com/Azure/azure-cli.git"

  bottle do
    cellar :any
    sha256 "8f06f5fedc8293d6495b6b4504b89a2ab967ffbb1e874d3e529380c11a8318c5" => :high_sierra
    sha256 "8bcfae41789536fcb7f8e6d87e9498b3d418b2fa6b1e77734788da43a115bc4d" => :sierra
    sha256 "ce446f37268b06242914af7581da4947c8ea524b6d8d8c034c1526331ea40b66" => :el_capitan
  end

  depends_on "openssl"
  depends_on :python3

  resource "adal" do
    url "https://files.pythonhosted.org/packages/00/50/0c6e9c4b52b9fd17800a3396abb14e5710ca5812d11ec9ab725026d31f78/adal-0.4.7.tar.gz"
    sha256 "114046ac85d0054791c21b00922f26286822bc6f2ba3716db42e7e57f762ef20"
  end

  resource "applicationinsights" do
    url "https://files.pythonhosted.org/packages/85/8e/0a35471fc38b9127df372f4e442ab4c90cf42e0dbc13bbe0944c30f34da8/applicationinsights-0.11.1.tar.gz"
    sha256 "a580794a66da1cd3b66ee5f3293b2d644c279e61ef60f2f38a5cc3af51354945"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/3b/db/c524f0d72842b44b179cc50d4257f1e72f447fef0919556e8b28a9b0f80f/argcomplete-1.9.2.tar.gz"
    sha256 "d6ea272a93bb0387f758def836e73c36fff0c54170258c212de3e84f7db8d5ed"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/31/53/8bca924b30cb79d6d70dbab6a99e8731d1e4dd3b090b7f3d8412a8d8ffbc/asn1crypto-0.23.0.tar.gz"
    sha256 "0874981329cfebb366d6584c3d16e913f2a0eb026c9463efcc4aaf42a9d94d70"
  end

  resource "azure-batch" do
    url "https://files.pythonhosted.org/packages/4e/24/b6764cbb01ea09a1a8f464869ecc926cbc1d4e6dca580b2d16c974e41449/azure-batch-4.0.0.zip"
    sha256 "35c617cb601dd286ea6d078f95e0c6b159b4c7974ed6f3693c6dffd2513285af"
  end

  resource "azure-batch-extensions" do
    url "https://files.pythonhosted.org/packages/32/ee/27896a170b84c4aee99d5d111490e186e45e797ec158d1f303cfd8b65683/azure-batch-extensions-1.0.1.tar.gz"
    sha256 "e35414a2ef18e4525b0841bff32eba268dc2f863c69891bab3aaccb444d898cc"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/85/76/8809248c38bf1c994f40bc07cf3a17dec0aa00ba0915f159c904b040893e/azure-common-1.1.8.zip"
    sha256 "25559617b41fe0902f34b215a3440a3ffa4862fe442bf351415be0e1d2eb4289"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/e1/ab/72c7c42220a6d881316bfbc4b1eace2ae37e6c291ccd13d6ae178fe388bd/azure-datalake-store-0.0.17.tar.gz"
    sha256 "9ff88f7e5ec58080155350fd23b9fc2b7f30bf7dda0b6e7397dde949d97937b7"
  end

  resource "azure-graphrbac" do
    url "https://files.pythonhosted.org/packages/33/0f/9bbc92a4566986a3f1de311e95cd5a1c6ba473783d2c9381be38d1f9d946/azure-graphrbac-0.31.0.zip"
    sha256 "faa7d632f13d5f99a704c561dca0711aa72f9b48b3494075c3d5a9f76734d61e"
  end

  resource "azure-keyvault" do
    url "https://files.pythonhosted.org/packages/10/92/24d4371d566f447e2b4ecebb9c360ca52e80f0a3381504974b0e37d865e7/azure-keyvault-0.3.7.zip"
    sha256 "549fafb04e1a3af1fdc94ccde05d59180d637ff6485784f716e7ddb30e6dd0ff"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/27/ed/e857a8d638fe605c24ca11fe776edad2b0ff697e2395fff25db254b37dfb/azure-mgmt-authorization-0.30.0.zip"
    sha256 "ff965fe74916974a51e834615b7204f494a1bad42ad8d43874bd879855554466"
  end

  resource "azure-mgmt-batch" do
    url "https://files.pythonhosted.org/packages/de/27/910b77c194c1e88f7e50dbb1132ed8afd834636bb5e2daf65c33caded215/azure-mgmt-batch-4.1.0.zip"
    sha256 "2e69f407dc8a94d87316ee6a82b6f3c1d6997b84e337042c3c4ed6450adcd359"
  end

  resource "azure-mgmt-batchai" do
    url "https://files.pythonhosted.org/packages/5c/e7/d29acdca0136c9e74cfcf8d78a12e9f890f77a66b375de7351f95dd2015e/azure-mgmt-batchai-0.2.0.zip"
    sha256 "35bda8468cedd0da03841789d96386f2d06d3789e53df72d9b620ac44e6b6f80"
  end

  resource "azure-mgmt-billing" do
    url "https://files.pythonhosted.org/packages/53/78/fccfdc17d9c22757a58ce96b6f46d6c136f56672e7f1f74032129d64a4ad/azure-mgmt-billing-0.1.0.zip"
    sha256 "56a4365ac272f0221f79396aaabb2217f5b5eb970d28f3d80f83efc5a9481532"
  end

  resource "azure-mgmt-cdn" do
    url "https://files.pythonhosted.org/packages/15/a3/33a514c152a474ccc49e787987dbc16612036625d6e2668ee5cb1b58c172/azure-mgmt-cdn-0.30.2.zip"
    sha256 "dd35d17f65aac8dee201e18c16bdd1689bfda4dc6464a3a08f0d6f9524cde629"
  end

  resource "azure-mgmt-cognitiveservices" do
    url "https://files.pythonhosted.org/packages/2d/98/998cc11d25751c3fc93078040c9f725641d34d3424dd9cada2b7edf585e4/azure-mgmt-cognitiveservices-1.0.0.zip"
    sha256 "9a124d5c8827c2af3eeb1e3829e116d0ae582d27eb0e49d6a250489b7be11582"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/33/34/27b48ea344325e06e71a752ac418ae0baf73e912a160393b85c39376bbb6/azure-mgmt-compute-3.0.1.zip"
    sha256 "7a28dbef42c4cfe70d9b3a9e9371668f0f448d343136ce98095b503a3085d854"
  end

  resource "azure-mgmt-consumption" do
    url "https://files.pythonhosted.org/packages/55/4c/9c8a4b8c32d56a99930cf5d13fc9da2e908e4a5dd043dfb9d449a05ae655/azure-mgmt-consumption-0.1.0.zip"
    sha256 "4fa769dc8f4db278d95f18da54d77028c18e3a804ae4f3b43a2ffaddb1153dfc"
  end

  resource "azure-mgmt-containerinstance" do
    url "https://files.pythonhosted.org/packages/35/26/c8ced74fe1a2f9a416276cc434120f55bfb9f913e3b7efb16d64c771149d/azure-mgmt-containerinstance-0.1.0.zip"
    sha256 "7ab9fc91604f82b6c49352a806758dbc92eef891fc37cb62a537ea049c2a7b25"
  end

  resource "azure-mgmt-containerregistry" do
    url "https://files.pythonhosted.org/packages/29/2d/2627d1790488a54ff6a91354ac22b1130467d4b301c6bc1de5d5c1737dd7/azure-mgmt-containerregistry-0.3.1.zip"
    sha256 "5b19d583594c10df2590f2a37de2bb1d2afeedd7aa55e49d62145b99abb01991"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/c2/34/73d91bb67d4a6a1127852863c50795bf5ae16b412f7ec293ec2af9a66ef0/azure-mgmt-containerservice-1.0.0.zip"
    sha256 "386afa8deda282d7eb1b8345dcad96662e6794024da5d326398482a1f90c8552"
  end

  resource "azure-mgmt-datalake-analytics" do
    url "https://files.pythonhosted.org/packages/3c/e4/dc69239e3a7923e34d7f1bbff7fbccd1ee6ff3fb729603b15a4b9e185a1a/azure-mgmt-datalake-analytics-0.1.6.zip"
    sha256 "acde5be6e04a8717cb3683715195047e05df1b7736b720bce23dc8ebd3e828e0"
  end

  resource "azure-mgmt-datalake-nspkg" do
    url "https://files.pythonhosted.org/packages/f7/eb/3b330ffd3a925db473175c3a28244bdf87c4736ce16a55be7a7535c6bfa5/azure-mgmt-datalake-nspkg-2.0.0.zip"
    sha256 "28b8774a1aba3e11c431f9c6cc984fde31a0ecbb89270924f392504f4260ca37"
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

  resource "azure-mgmt-eventgrid" do
    url "https://files.pythonhosted.org/packages/7c/af/41a7e70d7f0b3bcbd6e52eba4a54807dc4639642a9d2a1cfd1357132e926/azure-mgmt-eventgrid-0.2.0.zip"
    sha256 "2e039e3bc561f961a59150ed3c93d497d50db8a37fd75740a9d8f728c5336936"
  end

  resource "azure-mgmt-iothub" do
    url "https://files.pythonhosted.org/packages/28/83/ec3d8d9825f5084a8808ba0fa0c1e99e345855c8293b43e41020d6848a04/azure-mgmt-iothub-0.2.2.zip"
    sha256 "d6ffdd4a416c51ea83b55f1b5984ebfd3714c019c7c238974119d54092a7cd1a"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/e0/c2/6c572800601330c343f993b93432f06ff2abdc35ee40ef42f81ee3a00ec2/azure-mgmt-keyvault-0.40.0.zip"
    sha256 "fb7facbcdc9157f7fb83abb41032f257a6013a02205d7c0327b56779ca20fd30"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/0f/37/41817796c3887da9f7fa9d565db931cffa1e2d99ecc757cf9127885e6e83/azure-mgmt-monitor-0.2.1.zip"
    sha256 "717b9c57a3c61fbfdba6062b2b307bbd2c2befdea1072b1572ab7a20953168c8"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/b4/ab/4300eff535b4f64b5162e87f8ae5f58da4109554b7cf78e7fc2ff41ea66a/azure-mgmt-network-1.5.0rc3.zip"
    sha256 "6dab50c0d57b9bb7793a2750a1d6e9029ed134366897a3594f6828218afa0fc9"
  end

  resource "azure-mgmt-nspkg" do
    url "https://files.pythonhosted.org/packages/fe/66/66eb0d5ead69b7371649466fa160a166de0d1ddafc4a1d7a172858a8abc9/azure-mgmt-nspkg-2.0.0.zip"
    sha256 "e36488d4f5d7d668ef5cc3e6e86f081448fd60c9bf4e051d06ff7cfc5a653e6f"
  end

  resource "azure-mgmt-rdbms" do
    url "https://files.pythonhosted.org/packages/4f/bb/fd668496474ca4a43361a83e1db7de41d4f4ff632f74bd446ede9d9f7a2a/azure-mgmt-rdbms-0.1.0.zip"
    sha256 "c06419399f04e2757f447731a09d232090a855369c9f975fc90ed9a8bddd0b01"
  end

  resource "azure-mgmt-recoveryservices" do
    url "https://files.pythonhosted.org/packages/a3/e9/476dbfc13000f7eda49b18a0c109827841b5381ce15acb651b5b4dec248e/azure-mgmt-recoveryservices-0.1.0.zip"
    sha256 "bf875b8fbfe2459f4c729c363ec6721b8d33bd7fe74bcd0a8ce27f0fcdae5aef"
  end

  resource "azure-mgmt-recoveryservicesbackup" do
    url "https://files.pythonhosted.org/packages/9f/fb/731b07c573c660780e660d883cb1d1a6d09c1b4ebd5348383eae854a4024/azure-mgmt-recoveryservicesbackup-0.1.1.zip"
    sha256 "a09a514f5c7877406bdf777007683f036f5444f878cf595a15e541e7ba5c1c66"
  end

  resource "azure-mgmt-redis" do
    url "https://files.pythonhosted.org/packages/c6/e5/4e63b267b483deeca8e41eaa0b5f8ccff03a2196ad86e80f5fe7af78dec7/azure-mgmt-redis-4.1.0.zip"
    sha256 "7ef447e2fae80853672ef276af6867976e8315e8893beb7f3fb11697fb1fb4a8"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/1a/ee/85b690bcfb616a8434c245bac852aff4bb39b3c8a6d222ab2e1376335b28/azure-mgmt-resource-1.2.0rc3.zip"
    sha256 "57ecba99e8b6d1560031ef956ecde87f5546aa0b0a01c58958cbf878dfac2282"
  end

  resource "azure-mgmt-servicefabric" do
    url "https://files.pythonhosted.org/packages/e6/79/597d3e5fe6ee4ac44a42918e83a99734d25f38f0f3ef48b854bbac0a34a3/azure-mgmt-servicefabric-0.1.0.zip"
    sha256 "9f7789bdc221fcf81608cc5a3e64f1d59d41c453ff1567cb81197b19a2cd6373"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/71/bb/9d15a4f91b7c7827b5f9cf585c28522be271e4b722f225250b0bd1df5df8/azure-mgmt-sql-0.8.1.zip"
    sha256 "43d517a01c6d7dc2b1e7b4a40efad8c19f99bfd5e818e923230c4667e3515f63"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/aa/d9/3d51a19993de8ba9367e24838d8df5c585e9edac573eb3529c8bd7856681/azure-mgmt-storage-1.2.0.zip"
    sha256 "901dff3288b1542160b99b8103a209d9b1ace97a4682eb21d0a0223d75fa22c0"
  end

  resource "azure-mgmt-trafficmanager" do
    url "https://files.pythonhosted.org/packages/68/4f/c8b62406174c8355b2c1fb62720152c0bb8046dd62bb1029fcf8c8d049d2/azure-mgmt-trafficmanager-0.40.0.zip"
    sha256 "32cd1f5fd8d902cba5dd68f5876eadf5f98f5bef8b33319b20e6b547e7c21d68"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/94/dc/28167c592722316a94f8814610048faaf25cbde5935bb8fb568e142ca613/azure-mgmt-web-0.32.0.zip"
    sha256 "f5992c32c1fda3085dcc2276a034f95dbe7dadc36a35c61f5326c8009f3f1866"
  end

  resource "azure-monitor" do
    url "https://files.pythonhosted.org/packages/d1/f8/7f6a0aa50e2d99ba37885e05e5cd644ba35548d19f636edec0faecc8688e/azure-monitor-0.3.0.zip"
    sha256 "880a095967ce45f36ffcb21fb91b7722c6aee61952fc65c74377b15860c68ae3"
  end

  resource "azure-multiapi-storage" do
    url "https://files.pythonhosted.org/packages/6b/27/3a6209188f76ff1de54a7543d61438ac730ff14be9fe292b3fdb718ec8cc/azure-multiapi-storage-0.1.6.tar.gz"
    sha256 "fa1a4484714882d2b6d920c792317fa24ea12c66774585d386433bee4b6cbfa6"
  end

  resource "azure-nspkg" do
    url "https://files.pythonhosted.org/packages/06/a2/77820fa07ec4657d6456b67edfa78856b4789ada42d1bb8e8485df19824e/azure-nspkg-2.0.0.zip"
    sha256 "fe19ee5d8c66ee8ef62557fc7310f59cffb7230f0a94701eef79f6e3191fdc7b"
  end

  resource "azure-storage" do
    url "https://files.pythonhosted.org/packages/42/50/f038b43107a48db27fc016cb604341aa62a3946cee8f3d422075c96cde6e/azure-storage-0.34.3.tar.gz"
    sha256 "46415ba68e78ba10eab5d025e32b5bf9afe5b986060076313e05392409effdb3"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/58/e9/6d7f1d883d8c5876470b5d187d72c04f2a9954d61e71e7eb5d2ea2a50442/bcrypt-3.1.3.tar.gz"
    sha256 "6645c8d0ad845308de3eb9be98b6fd22a46ec5412bfc664a423e411cdd8f5488"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/20/d0/3f7a84b0c5b89e94abbd073a5f00c7176089f526edb056686751d5064cbd/certifi-2017.7.27.1.tar.gz"
    sha256 "40523d2efb60523e113b44602298f0960e900388cf3bb6043f645cf57ea9e3f5"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/c9/70/89b68b6600d479034276fed316e14b9107d50a62f5627da37fafe083fde3/cffi-1.11.2.tar.gz"
    sha256 "ab87dd91c0c4073758d07334c1e5f712ce8fe48f007b86f8238773963ee700a6"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/e6/76/257b53926889e2835355d74fec73d82662100135293e17d382e2b74d1669/colorama-0.3.9.tar.gz"
    sha256 "48eb22f4f8461b1df5734a074b57042430fb06e1d61bd1e11b078c0fe6d7a1f1"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9c/1a/0fc8cffb04582f9ffca61b15b0681cf2e8588438e55f61403eb9880bd8e0/cryptography-2.0.3.tar.gz"
    sha256 "d04bb2425086c3fe86f7bc48915290b13e798497839fbb18ab7f6dffcf98cc3a"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/0e/1b/154666b208625dd4d946e949c4aa39d9150f4dac00796f0ec6b9a3abac7e/humanfriendly-4.4.1.tar.gz"
    sha256 "f1ebb406d37478228b92543c12c27c9a827782d8d241260b3a06512c7f7c3a5e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/f4/5b/fe03d46ced80639b7be9285492dc8ce069b841c0cebe5baacdd9b090b164/isodate-0.5.4.tar.gz"
    sha256 "42105c41d037246dc1987e36d96f3752ffd5c0c24834dd12e4fdbe1e79544e31"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"
    sha256 "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/37/0c/034139cd798dac3ceb4fcb4ed85e20c27f3e579c25cdaf066aad1552da3d/keyring-10.4.0.tar.gz"
    sha256 "901a3f4ed0dfba473060281b58fd3b649ce70f59cb34a9cf6cb5551218283b26"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/93/00/80bfbc79c4880a3d0c6cce726a1eb9500fc5fe4d0832237d63812072534f/msrest-0.4.16.tar.gz"
    sha256 "43bf9d3eaa98d3a0102a50032f8282855fd313bd3e094f58ff611f6f1dbe387d"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/6b/1e/c5c33bb07de13ab4cbe0949b3490f22a1614f47c11c3513d034b8d14941a/msrestazure-0.4.14.tar.gz"
    sha256 "084e2f23fb8ee77900790103b8554106fe16a60a2f69a20514b365c3579c97b5"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/78/46/c19c2d374a37d218c551717d873670216af7242bc92958df1701dcc5e76d/oauthlib-2.0.4.tar.gz"
    sha256 "514e293cb356dd53d596692207d48d9231b997995c9a4167eefa868583d74d13"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/83/78/4569a543ef2cb304e9b82387f555021c13a845d0ad1e2bb59272ade67669/paramiko-2.3.1.tar.gz"
    sha256 "fa6b4f5c9d88f27c60fd9578146ff24e99d4b9f63391ff1343305bfd766c4660"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/d5/d6/f2bf137d71e4f213b575faa9eb426a8775732432edb67588a8ee836ecb80/pbr-3.1.1.tar.gz"
    sha256 "05f61c71aaefc02d8e37c0a3eeb9815ff526ea28b3b76324769e6158d7f95be1"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/8a/ad/cf6b128866e78ad6d7f1dc5b7f99885fb813393d9860778b2984582e81b5/prompt_toolkit-1.0.15.tar.gz"
    sha256 "858588f1983ca497f1cf4ffde01d978a3ea02b01c8a26a8bbc5cd2e66d816917"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/3c/a6/4d6c88aa1694a06f6671362cb3d0350f0d856edea4685c300785200d1cd9/pyasn1-0.3.7.tar.gz"
    sha256 "187f2a66d617683f8e82d5c00033b7c8a0287e1da88a9d577aebec321cad4965"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pydocumentdb" do
    url "https://files.pythonhosted.org/packages/25/d5/fa2c93783843670b77ee5b0dc34fbe43b81d5ed7f26a56dfb06f02975894/pydocumentdb-2.2.1.tar.gz"
    sha256 "82e5cc8d0926290840b026c7e61c19c2b658b675615b7e49bb1eec4ecb9089d8"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/c9/2a/ffd27735280696f6f244c8d1b4d2dd130511340475a29768ed317f9eaf0c/PyJWT-1.5.3.tar.gz"
    sha256 "500be75b17a63f70072416843dc80c8821109030be824f4d14758f114978bae7"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/8d/f3/02605b056e465bf162508c4d1635a2bccd9abd1ee3ed2a1bb4e9676eac33/PyNaCl-1.1.2.tar.gz"
    sha256 "32f52b754abf07c319c04ce16905109cab44b0e7f7c79497431d3b2000f8af8c"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/ee/6a/cd78737dd990297205943cc4dcad3d3c502807fd2c5b18c5f33dc90ca214/pyOpenSSL-17.3.0.tar.gz"
    sha256 "29630b9064a82e04d8242ea01d7c93d70ec320f5e3ed48e95fcabc6b1d0f6c76"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/a4/09/c47e57fc9c7062b4e83b075d418800d322caa87ec0ac21e6308bd3a2d519/pytz-2017.2.zip"
    sha256 "f5c056e8f62d45ba8215e5cb8f50dfccb198b4b9fbea8500674f3443e4689589"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5/requests-oauthlib-0.8.0.tar.gz"
    sha256 "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/1d/a9/618f1e40e30c69ffab668493953e74e6c266f383af6e34e1b8f089e41139/scp-0.10.2.tar.gz"
    sha256 "18f59e48df67fac0b069591609a0f4d50d781a101ddb8ec705f0c2e3501a8386"
  end

  resource "SecretStorage" do
    url "https://files.pythonhosted.org/packages/a5/a5/0830cfe34a4cfd0d1c3c8b614ede1edb2aaf999091ac8548dd19cb352e79/SecretStorage-2.3.1.tar.gz"
    sha256 "3af65c87765323e6f64c83575b05393f9e003431959c9395d1791d51497f29b6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "sshtunnel" do
    url "https://files.pythonhosted.org/packages/dc/06/1d9969bbe7ad6895983016666699af2ab0b24d270c0abdecf51797d126cc/sshtunnel-0.1.2.tar.gz"
    sha256 "11032e23af010da81366ef944e8cb1cf508731e1d953463a420075acdfc02047"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/1c/a1/3367581782ce79b727954f7aa5d29e6a439dc2490a9ac0e7ea0a7115435d/tabulate-0.7.7.tar.gz"
    sha256 "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "vsts-cd-manager" do
    url "https://files.pythonhosted.org/packages/8c/bf/e8aa32b26a739254dd296dab8ae206df5d0fb806ce462fa65dab958441a2/vsts-cd-manager-0.118.0.tar.gz"
    sha256 "5dc969725872c6dd1a0eee29cc59ef9dcb51fb7a210d5c93afba092723df4326"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fa/b4/f9886517624a4dcb81a1d766f68034344b7565db69f13d52697222daeb72/wheel-0.30.0.tar.gz"
    sha256 "9515fe0a94e823fd90b08d22de45d7bde57c90edce705b22f5e1ecf7e1b653c8"
  end

  resource "Whoosh" do
    url "https://files.pythonhosted.org/packages/25/2b/6beed2107b148edc1321da0d489afc4617b9ed317ef7b72d4993cad9b684/Whoosh-2.7.4.tar.gz"
    sha256 "7ca5633dbfa9e0e0fa400d3151a8a0c4bec53bd2ecedc0a67705b17565c31a83"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/57/17/a6acddc5f5993ea6eaf792b2e6c3be55e3e11f3b85206c818572585f61e1/xmltodict-0.11.0.tar.gz"
    sha256 "8f8d7d40aa28d83f4109a7e8aa86e67a4df202d9538be40c0cb1d70da527b0df"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    site_packages = libexec/"lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", site_packages
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib}"
    ENV.prepend "CFLAGS", "-I#{Formula["openssl"].opt_include}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl"].opt_include}"

    # Get the CLI components we'll install
    components = [
      buildpath/"src/azure-cli",
      buildpath/"src/azure-cli-core",
      buildpath/"src/azure-cli-nspkg",
      buildpath/"src/azure-cli-command_modules-nspkg",
    ]
    components += Pathname.glob(buildpath/"src/command_modules/azure-cli-*/")

    # Install dependencies
    # note: Even if in 'resources', don't include 'futures' as not needed for Python3
    # and causes import errors. See https://github.com/agronholm/pythonfutures/issues/41
    deps = resources.map(&:name).to_set - ["futures"]
    deps.each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec)
      end
    end

    # Install CLI
    components.each do |item|
      cd item do
        system "python3", *Language::Python.setup_install_args(libexec)
      end
    end

    # This replaces the `import pkg_resources` namespace imports from upstream
    # with empty string as the import is slow and not needed in this environment.
    File.open(site_packages/"azure/__init__.py", "w") {}
    File.open(site_packages/"azure/cli/__init__.py", "w") {}
    File.open(site_packages/"azure/cli/command_modules/__init__.py", "w") {}
    File.open(site_packages/"azure/mgmt/__init__.py", "w") {}

    (bin/"az").write <<-EOS.undent
      #!/usr/bin/env bash
      export PYTHONPATH="#{ENV["PYTHONPATH"]}"
      if command -v python#{xy} >/dev/null 2>&1; then
        python#{xy} -m azure.cli \"$@\"
      else
        python3 -m azure.cli \"$@\"
      fi
    EOS

    bash_completion.install "az.completion" => "az"
  end

  def caveats; <<-EOS.undent
    This formula is for Azure CLI 2.0 - https://docs.microsoft.com/cli/azure/overview.
    The previous Azure CLI has moved to azure-cli@1
    ----
    Get started with:
      $ az
    EOS
  end

  test do
    json_text = shell_output("#{bin}/az cloud show --name AzureCloud")
    azure_cloud = JSON.parse(json_text)
    assert_equal azure_cloud["name"], "AzureCloud"
    assert_equal azure_cloud["endpoints"]["management"], "https://management.core.windows.net/"
    assert_equal azure_cloud["endpoints"]["resourceManager"], "https://management.azure.com/"
  end
end
