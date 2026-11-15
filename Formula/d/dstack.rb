class Dstack < Formula
  include Language::Python::Virtualenv

  desc "ML workflow orchestration system designed for reproducibility and collaboration"
  homepage "https://dstack.ai/"
  url "https://files.pythonhosted.org/packages/63/35/bd52170618ce6fe66b0e13ccffb1c1cb9a90be09802e468302a5e29eb3c6/dstack-0.22.8.tar.gz"
  sha256 "61edd54e020ce647fe5672995660ab8988f62db37265cc86e6f82765dfe5de4f"
  license "MPL-2.0"
  head "https://github.com/dstackai/dstack.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4193d12de2ba7c439686ced4295bf380ee84e93209834aaa7fcb430b755d453b"
    sha256 cellar: :any, arm64_tahoe:       "b37ef2ff64bbfa1822c9816f1a28da34c3f25d7965bb27cb060abc238ce2b05c"
    sha256 cellar: :any, arm64_sequoia:     "ffac5c1c5b16588a119b12a421229e6f446738da58bd491139006a79fe0f7554"
    sha256 cellar: :any, arm64_linux:       "45386b7d114b17317e4c545d5162c650684019f6d6b7cbeda4e830bb33a8e35f"
    sha256 cellar: :any, x86_64_linux:      "dd3da60171ecbf3c6f355042ce32c4d208d646244ce924ca74eff1dba4127d59"
  end

  # `pkgconf` and `rust` are for bcrypt
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  pypi_packages package_name:     "dstack[aws,azure,gcp,lambda]",
                exclude_packages: %w[certifi cryptography pydantic rpds-py]

  resource "aiocache" do
    url "https://files.pythonhosted.org/packages/7a/64/b945b8025a9d1e6e2138845f4022165d3b337f55f50984fbc6a4c0a1e355/aiocache-0.12.3.tar.gz"
    sha256 "f528b27bf4d436b497a1d0d1a8f59a542c153ab1e37c3621713cb376d44c4713"
  end

  resource "aiorwlock" do
    url "https://files.pythonhosted.org/packages/6b/65/316cdc82c1b92953235ced1c71a3763f0cd9273c3bec5db60bdb5ad59bfe/aiorwlock-1.5.1.tar.gz"
    sha256 "2729c77ec736c8d85ec305aa3827a50394fd8c6d823f4404d301cc8c59a4b7f5"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/4e/8a/64761f4005f17809769d23e518d915db74e6310474e733e3593cfc854ef1/aiosqlite-0.22.1.tar.gz"
    sha256 "043e0bd78d32888c0a9ca90fc788b38796843360c855a7262a532813133a0650"
  end

  resource "alembic" do
    url "https://files.pythonhosted.org/packages/93/1c/00909e0fbebad2121d916fdcab044cae988146680e9ee4387ba25fef8747/alembic-1.20.1.tar.gz"
    sha256 "83490def1f723413db5096591f7609ac52544805be93849170088ed04f5a2e0b"
  end

  resource "alembic-postgresql-enum" do
    url "https://files.pythonhosted.org/packages/4c/95/8aab40c2b867b0bc75fcfe30fd08ebd52f481182b86615e28a73dcab216e/alembic_postgresql_enum-1.11.1.tar.gz"
    sha256 "66277c112ef86c30c73e06bfb6deedd4cb62ec0a9e6017bcaee0c0d43a085f23"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/0f/6e/a61e86e43bb6039b31a33a8f5fba76fe1cdacf3661e7b9756d4ff1b28cdc/annotated_doc-0.0.6.tar.gz"
    sha256 "7969bb69912085b2285849c0dcac0b4b374fd180c13cf10a87f284ffcf347bbf"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/8c/6b/eeff360196bb20b312c9e762a820fd1b2c6d809466c755ef57863478e454/apscheduler-3.11.3.tar.gz"
    sha256 "cd2fcc9330039a81a5893472ad49facf23a6d5604cbe1d918c835c6de7834d5a"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "asyncpg" do
    url "https://files.pythonhosted.org/packages/80/4e/59dc964f962f09e3ed472e5d2d3ba670a41a2be25080dc62ab3db507ff5e/asyncpg-0.32.0.tar.gz"
    sha256 "45e64e56714d888330b884aad1dfb363d0bf43fb343e3d1a8968525f3bade478"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/a6/f3/b416179e408990df5db0d516283022dde0f5d0111d98c1a848e41853e81c/azure_core-1.41.0.tar.gz"
    sha256 "f46ff5dfcd230f25cf1c19e8a34b8dc08a337b2503e268bb600a16c00db8ad5a"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/cf/33/0b881d0093d64c965bb20fcf71b806c7097881b544a2a55d519cdcf3bab9/azure_identity-1.27.0.tar.gz"
    sha256 "6a4c50e25e8e9a47b324a95ad024897e56cb3c6241e0094e93b126a2bf71edc5"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/67/d9/dd0efc9a4d74f19f860b2eeae7635b0a2da72229220d8324b0b06d1f01ce/azure_mgmt_compute-39.0.0.tar.gz"
    sha256 "0187dd028afcbab87d435498cd169f9e54fbb57c08785bcd59008a9a012861fa"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/3e/99/fa9e7551313d8c7099c89ebf3b03cd31beb12e1b498d575aa19bb59a5d04/azure_mgmt_core-1.6.0.tar.gz"
    sha256 "b26232af857b021e61d813d9f4ae530465255cb10b3dde945ad3743f7a58e79c"
  end

  resource "azure-mgmt-msi" do
    url "https://files.pythonhosted.org/packages/f8/83/f2e8eeca619905ffc48205664ad10e7cdfc168be522a06d04bea54e41556/azure_mgmt_msi-7.1.0.tar.gz"
    sha256 "1a01a089f1f66cb0d4b2886603d5ba415f360eff0be6f685737ecdd59c78225b"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/bf/aa/bf464fd70eefa8f13f5e5b45d021416d5c9c8d79eabb96f4a673fe91346d/azure_mgmt_network-27.0.0.tar.gz"
    sha256 "5c1c61d8bb13ad40f788a26fd7569c1d9d60eb2e4cb19c2a1b5d9c02ae862316"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/61/e1/c6196381cc6bb3eff9e24f5bf31b7fd962651ddbd6120bc2a4c482a7af16/azure_mgmt_resource-26.0.0.tar.gz"
    sha256 "54227c5db06d3be4dd4b77ad885b273e9eb2606d1de653c5b534066cfbb60c0c"
  end

  resource "azure-mgmt-subscription" do
    url "https://files.pythonhosted.org/packages/84/67/14b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1/azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/91/02/d46523af0a933c35604e2bbb33e4ca8f69a00f9990af6d6b29ed84db64aa/boto3-1.44.1.tar.gz"
    sha256 "c81dfdaab894cbcba78aa3773fe3fb27a13b576f49ff5552b91190072fc7dac0"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/b1/61/07918ec258ab7131dd601cb1aaffcd7fa008fa8bb0143fd195ecc4b4435d/botocore-1.44.1.tar.gz"
    sha256 "e71f6249be2a7324899ba81c5958ac1809a78498ea2c8f60e00fc0e62262ab83"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/e6/60/ac2d44dbfcca28a35151af27ad9c6236d913a67768b5bb88af90a8c02943/cachetools-8.0.0.tar.gz"
    sha256 "5ed01bd676800d51f0025605e4fd8ad0891550513e7b0a4c3da478463764e5c3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "cursor" do
    url "https://files.pythonhosted.org/packages/a8/fe/63dc53e5cf7e2c20b6d5b43a92038846e2e301479435203c1d4d857e527c/cursor-1.3.6.tar.gz"
    sha256 "ff3586de5a8e9367b689b31092d3f681b03efc92fdcf10aea538778e80f9b67a"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/88/7f/731ff914b0255d3d065f45fd4e626d4b8c95dbcbaada049f337a6ac16410/docker-7.2.0.tar.gz"
    sha256 "cebb93773d334f778e023a7ee352a8d6e13ab1bd3b863a4d4a59dec897df43ac"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/4e/7b/ae546e10f153fcf9a6afd8b9fe4730bdfeb8fdcb93178d54122973ef3f4c/fastapi-0.162.5.tar.gz"
    sha256 "1ca37f64f61c99cebd38636e67525fb721c5e8c1169f07f2a35d73b0a63265d4"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/a1/cf/05bcdacabdc0aec7dc8e19d76281bd82325df62dae3b6430e9ba57397689/filelock-4.2.10.tar.gz"
    sha256 "fcc3c0cb8bfe7f4b3bb0e231c04b15dbad068cb3c2515f343d8fde4dce93bd5d"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c0/ff/fee293f1ec3e1b64db6eb270e00964f29c086d769201474cedb8d1608930/gitpython-3.2.1.tar.gz"
    sha256 "0f1229ec5c057bdabdeeda8bda4f17bda679ab33dbccc00f24e6a480553c8613"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/72/ef/63d89cb580f3a42c51db53b3d151352aa61b9c87ea8cfdd8d24ee6caa09d/google_api_core-2.44.0.tar.gz"
    sha256 "5ab9a396965c1227d7dea4581e562b7018aa2bca96d2de0be5eb70dc9c8ab3a1"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/22/59/70df770dd367e268f0382fc98c6976d1e210e47351f263cced5b95989ee0/google_api_python_client-2.202.0.tar.gz"
    sha256 "ae126c8e91f43c331e23dbd83bc4a8075699dd48089cebc7295f6ab2f5850fc5"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/4a/d4/87353e950d653d87360176363d51f316e8e368e1ddbb7ba7aa5503c30c3e/google_auth-2.62.2.tar.gz"
    sha256 "046c61a72d3a847d6df6417a7f0d5cf054e3b82bbcb54fb1e69d47880964049c"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/bb/6d/a511ca64d5412850e351bdec6bb224e5090749bd85c186135e8fdb4fd85a/google_auth_httplib2-0.4.4.tar.gz"
    sha256 "b931de392c20cfaa351cd789274922bd8cdc001e0e9e96de31b39d71347f8e16"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/ac/34/aec7eca310c84a106a22dfaad076766c2e2ebe0389bdb88270a22c807f9d/google_cloud_appengine_logging-1.11.0.tar.gz"
    sha256 "ce053792df98fde4790c5f070176088c9ebf0e55a37c754c8f8e11b28ddb4d73"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/20/cd/5f73ed48869615dfc041368e9846154d61ab60e399adcd18594b73df3dec/google_cloud_audit_log-0.6.3.tar.gz"
    sha256 "ea963f8327325d53f660aabe3a67ab3fd5c124b3a9fead46e0d2f8c1a444643d"
  end

  resource "google-cloud-billing" do
    url "https://files.pythonhosted.org/packages/45/72/9180c8af3ee6fb6bbfdef9434f2f286424733f9823f4627d74467709e2a4/google_cloud_billing-1.21.0.tar.gz"
    sha256 "735a5dff7d95f700abdea5248b625af5a4991311da7298087395071f0db2427e"
  end

  resource "google-cloud-compute" do
    url "https://files.pythonhosted.org/packages/62/f1/2b627c411aa9207e421fa51fbbaff0d3a9746022a2ab835f4da5b5cb26ff/google_cloud_compute-1.57.0.tar.gz"
    sha256 "772d1457652cf5824583d7996a9b885fd5f5726394c55490ca99c2eb78a0e09c"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/55/71/d6081acadf55d4233271c39860f0d140ef61fbdb4bceb2075e9c2905d947/google_cloud_core-2.8.0.tar.gz"
    sha256 "365f8e4518ae81c8101b8dea5fc1c32a960badedb8b511f19db2843cbbd285d2"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/e1/5b/fbb367f8bb05b3e968048686f440181765a8681c3a07cfa901814f9280e1/google_cloud_logging-3.17.0.tar.gz"
    sha256 "d7343f2b82b4f9e9244bfc8aba7ad034c415f9bbb405ed28d1125aa37d270b72"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/1d/d8/9d6444c1bc301bd4bad36cc91306524e8aba670cbefcc0d2fc184c88fbea/google_cloud_storage-3.17.1.tar.gz"
    sha256 "b24df37900f5e0a93518bd7d3a2a7b7b48d8a1e72add8eb57d53a38b8b2b0640"
  end

  resource "google-cloud-tpu" do
    url "https://files.pythonhosted.org/packages/a8/12/d98d5f640448b6e4440c895c8cd5fa932e5e7830c2526ca3893d29c448cc/google_cloud_tpu-1.28.0.tar.gz"
    sha256 "ab2efe308a16b85972cb4318bed65246c5357345ab675dda0adcd2ce3202a4c6"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/fa/25/9cb0c1c31c45b893eb8f11ae70b3f4309432d59b5acaebca5dbe791729a4/google_crc32c-1.9.0.tar.gz"
    sha256 "7b8c84c3d159ab6817fe3f74e6e6cef099c3f95dcec3abc0d8afb1404642efbe"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/cf/64/df6a482d5aa39d7f7be186d892377d605cae6c88525fd851d456e8bbe9c9/google_resumable_media-2.11.0.tar.gz"
    sha256 "febd83686752799661b4de575f0b993c5c25c349a5362556fc4d7be164056a37"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/62/b6/bc095b23a3e0d978e75c8c18cabe4c11f791837410670e4486f0d539bfba/googleapis_common_protos-1.76.0.tar.gz"
    sha256 "71db0e44a1d4c2dd024ebad44ca67129cc1e2892e4861df466764749d5ef8642"
  end

  resource "gpuhunt" do
    url "https://files.pythonhosted.org/packages/57/63/036fe13718226e4664e0c061ac7e940a2d4724032be7258b5307fb8aeed6/gpuhunt-0.1.35.tar.gz"
    sha256 "c742cbaee05c144ed87d4d3b78ad5d82417945d90461792be455361d4d919ec5"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/3e/6e/0091f175ccd02b02bc8811bbcbcc6ac2e980be116e3b2f7a736ca322bf84/greenlet-3.5.6.tar.gz"
    sha256 "8e67c43bdfc88d5fee6db0d3e40175b362fc95fb85f0412d233b9b203c53a575"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/97/24/0ef24ccdd91ce07be7d6466d39becdd4fbb33e52426ba2391fe334d24bca/grpc_google_iam_v1-0.14.6.tar.gz"
    sha256 "fc0a683ace0a149184fcd08d667dd64d51ae65e5698e86f7136aa6002a8b5373"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/f0/03/f9e805772d4d01da2a1754a5f63c58601eacaf8f1e878729217188de7d16/grpcio-1.85.1.tar.gz"
    sha256 "5f530287d5de5f7f66089ead81de44f6787162944dab3922efa65dfdff108a1d"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/fe/16/0a161d0016f6e318ebf217780a91e007a67d9d244a06f79caeef689f5f02/grpcio_status-1.85.1.tar.gz"
    sha256 "3f6ba6090d794b7148b23f03355addd56bee2b78174a12784c4d9b4e28c8928e"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/93/da/affa4b2adc11468c7d88d9b4258cac432479046edcf212284b55d4528593/httplib2-0.32.1.tar.gz"
    sha256 "37900eb8a74576bd99fc39ae1dc8409f95f965d45b56cbcb2194bb55f58a90e1"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/3a/ec/deed52912ab7ca6c0b12859330c571c60c61d7267b341b28951fcbf13694/httptools-0.9.0.tar.gz"
    sha256 "d484ebb7e3a3f3597b0f645fbd1b85633674ca808c1f5ba11c2caf7c66f5c8b6"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/92/5f/2c1465ef40f57ddff28254a426df2724b70593b899ec5dbeaac3aa01d307/ignore_python-0.4.2.tar.gz"
    sha256 "d7bac12afa8ddf5aabcecac701d8325e417ad989143f44da508c36ebcbd81565"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/33/f6/227c48c5fe47fa178ccf1fda8f047d16c97ba926567b661e9ce2045c600c/invoke-3.0.3.tar.gz"
    sha256 "437b6a622223824380bfb4e64f612711a6b648c795f565efc8625af66fb57f0c"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5a/09/e07c4b5579a79f4b16f8d4f29f6c54514ac787c4ad506b8c4f28a0e6b0bf/mako-1.4.3.tar.gz"
    sha256 "cd6537fe88d5fec315c55c2f8529bc4ce7a9a352ad7db3eeaa6a66e2dd4ec37a"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/bb/85/747d28986a44b715cc51cf57aa021c8fd94e9614064261ceec77320e8b0b/msal-1.39.0.tar.gz"
    sha256 "6ab7de335e6d7f5717e2c7e1dbf86e4dda2f6acf3c56773b78dc53ebc6395b5f"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/33/17/2bb072de0b990303c985f26869fd47bb179024a051f47e7f9d208eb92f8e/oauthlib-4.0.1.tar.gz"
    sha256 "3d73febdb6faa00f277c81fb04be7b7586fb96fc3b7f0b9c772dada69a25ede7"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/19/14/cf3a6b6448849656e1e5f4e2101f3988dc6789724050096aba1bc5ccf592/opentelemetry_api-1.45.2.tar.gz"
    sha256 "d7b0008e21e5fd61cbe7a7f34ca3b6905a78ab677d9bc395e299359c75cda6b4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/76/cb/b1fde76618d84b1acf54d3d03d2b833ba5878afd12b9899346cc080f209d/paramiko-5.1.0.tar.gz"
    sha256 "239b5f9b2a53006cd54f83cf8495ee742083708ead947882c8dd2786de79f39b"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/52/73/f1334c29c2af4cd9dba6c7817e61b611bd0215e2eb5565c6064a4de18802/prometheus_client-0.26.0.tar.gz"
    sha256 "04a91bcf94e2cf74a44a1a874d651a2e853ed354b6e822f3b7487751465d5c2b"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/46/70/783e33ffbb4466cc154a94f79b869b92a451e2bd45605054e68ff68b7af6/proto_plus-1.29.0.tar.gz"
    sha256 "cfb4e62ad7e13dd18f346cabbda00cab39930d36a05791fd81ddb074d6ee884f"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/88/7e/3c0da41061a2021cac7cd524fd57092adbe5b515e8bf9005702e366802e2/pyasn1-0.6.5.tar.gz"
    sha256 "6b11616a6bcf3a40e635f082bb232fa57b5e0dd7f517bd7ddd69ec3794508a47"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "python-dxf" do
    url "https://files.pythonhosted.org/packages/ed/55/4b4fd31f5e5f7dc559a36c75e98b37670d6ddbd2b6b259e3a2bc8694cc2f/python_dxf-12.1.1.tar.gz"
    sha256 "2f5fd883599f8553872e1f7a67b8d278744ab574f55feb9790c93a347520dd9d"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/21/25/5473e46b179f8e8b4ad3aeeb36773d1701b7770eaf5e5bc2025c7303b598/python_json_logger-4.2.0.tar.gz"
    sha256 "e371ebe22ec01e289850102091a2b1f6fc9e655c7f1f5f29073936756c290afa"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/9f/b7/15b905f6142a9a8a68f66900788da1a32e4d4254452783b37ad1eccb0506/python_multipart-0.0.33.tar.gz"
    sha256 "b8112424a6abd162ec08d390565dd113ad699f2fe6fef3c987b8bbcbfe9e390d"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/f6/45/eafb0bba0f9988f6a2520f9ca2df2c82ddfa8d67c95d6625452e97b204a5/questionary-2.1.1.tar.gz"
    sha256 "3d7e980292bb0107abaa79c68dd3eee3c561b83a0f89ae482860b181c8bd412d"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/22/80/44636b363e75af7f5e6ac0571137466fec66e47016179139d0019a453ab7/requests_unixsocket-0.4.1.tar.gz"
    sha256 "b2596158c356ecee68d27ba469a52211230ac6fb0cde8b66afb19f0ed47a1995"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/6a/e5/1064c43203a357d668cd42435f7a15fe6af51512d85b2104fecb937aa861/rich_argparse-1.8.0.tar.gz"
    sha256 "679df3d832fa94ad6e4bdb07ded088cd7ea2dddc58ae9b2b46346a40b06cbc0c"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/c5/0a5ce655109cb96b8dfad36908a4e108d15f5dc2eff8fbc3146c4312e704/s3transfer-0.19.3.tar.gz"
    sha256 "8326acc3d056d7f7b8a37110c7d2aea41f67e83f6ae79cd3b5fbcca34c726406"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/d2/95/121b20d75e738d249a0e26e6476a2acb178673e8228002748fc0cd85ce55/sentry_sdk-2.75.0.tar.gz"
    sha256 "c38ac2d4b2435c11da821e173bb9d9088c98f41ae92f559ce0e424170a8e1a29"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smg-grpc-proto" do
    url "https://files.pythonhosted.org/packages/66/e0/a8c0499bb4fbfebe4ff51ec674ded489cccbcf243f7f9e2ca09a45838608/smg_grpc_proto-0.4.9.tar.gz"
    sha256 "ea54704ab92452d9ce13371dc65234799bfd18cc1fcd6806a9d0c3e23e149d20"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/9c/e7/2855174facf54a83b4fa3eddcece3631c6bdae43605dacd69cc3b6794319/sqlalchemy-2.1.8.tar.gz"
    sha256 "8bc4081dd7c17c073f2384ad0f5ee968e63b43507b2e024a3523c000a06d70da"
  end

  resource "sqlalchemy-utils" do
    url "https://files.pythonhosted.org/packages/2f/91/8a0d686dbc6213f3e9d073a196e2a1846a3d140f90862ccbec85c3258408/sqlalchemy_utils-0.43.0.tar.gz"
    sha256 "7e8741dbc2c0f992d2181cd69de13de292b3a2a5305a9da832e10d540abcedbf"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/48/bb/3d8757f21e9a53d9035c9eb039a777047139a16bfdbedfc7a58241c3d914/starlette-1.10.0.tar.gz"
    sha256 "b8399098d4c1e3522734f7235dc79b1fc967f96cf139c81e0fa30479e0685f9b"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/d8/89/2bd035df331499589fc92e59375c17c6cea6a500453b2c5f6a6ec9572825/tzlocal-5.4.5.tar.gz"
    sha256 "ba976898bad27945178c9ca25c222c19e322b30c10342b9f40b46714f70d2d5f"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/da/34/30e9280707135d2cfc589dfff3cb796bd07a3aeb1a3e415ba09dd89d7bb4/uvicorn-0.54.0.tar.gz"
    sha256 "a2e33cbfaa0306f8e6b0c13e0cb89d7d7a2da3e62b90c66e18c33d9807b28620"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/fa/42/02c739ce85fb2ee8d99212c61417da8140c6b87e9d97c430bea520d76044/uvloop-0.23.0.tar.gz"
    sha256 "28d160f51ab4da3b187063652e643dea6831072add4adc1e6d62afbe73b6be27"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/b3/68/e6aa0b77d217b31f8f486ec0cdfe5e00e6e38dc0be657e7d85819b9faf0a/watchfiles-1.3.0.tar.gz"
    sha256 "99aee4a07847c06820765fd7b1b49ceac4f3f711ccb7d104655a33231de1c207"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/d8/cb/a5abcc2891249f393827c650c6296660ce40374ac22d99ab9aea41f9d2a2/websocket_client-1.9.2.tar.gz"
    sha256 "0fcb57545848be86992e128218fd96dd87a6769ffdb1a968dff79632b85604d0"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/75/79/590c5f0cc7d1661195aeefccb0e342b79f4c77d368d526d028821a390332/websockets-17.4.tar.gz"
    sha256 "09d3939b70df0c8ad2da145ebd50978bccaee1d565e838b0e7921a34d38571eb"
  end

  resource "www-authenticate" do
    url "https://files.pythonhosted.org/packages/a7/2d/5567291a8274ef5d9b6495a1ec341394ab68933e2396936755b157f87b43/www-authenticate-0.9.2.tar.gz"
    sha256 "cf75fc2ea5effb0f9342d7de7619b736f2a7d4b223331a53e296863a286e9dcb"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"dstack", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dstack --version")
    expected = "Git repo not found:"
    assert_match expected, shell_output("#{bin}/dstack init 2>&1", 1)
  end
end
