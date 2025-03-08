class Dstack < Formula
  include Language::Python::Virtualenv

  desc "ML workflow orchestration system designed for reproducibility and collaboration"
  homepage "https://dstack.ai/"
  url "https://files.pythonhosted.org/packages/98/0c/5e0c8c16d42dfba4f80d96eef802cd7902581e043f437843882b190acacc/dstack-0.18.44.tar.gz"
  sha256 "26495d341265e77c374d5971d5c12b7a95514f65e07639a76f72f247aa21f4c8"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ac2e1adc7f5ceed255476ef761463540c2e292fa56c68de61404b268970aea7"
    sha256 cellar: :any,                 arm64_sonoma:  "afddb712738d7c9e57e1bb3a74944f15867b38f535069edc79a8bfa8e9d1d0fd"
    sha256 cellar: :any,                 arm64_ventura: "bf227c86823bd50f808aeb1e7b2179f4cc09f8905b9e2c881fe0ccaa452cdf0e"
    sha256 cellar: :any,                 sonoma:        "2b3cbd817ea8acec4bd73c5981e129af1c92514a769359671a295792f785db2d"
    sha256 cellar: :any,                 ventura:       "061166da0fac0aa513e439b0fc97c1461691bcaf2cb65d0dfa35fb91ff1c5e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aebe2f068659f54d8a29050349e6fff8cc852b77a8ea8f968b50460e19677c8d"
  end

  # `pkgconf` and `rust` are for bcrypt.
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "aiocache" do
    url "https://files.pythonhosted.org/packages/7a/64/b945b8025a9d1e6e2138845f4022165d3b337f55f50984fbc6a4c0a1e355/aiocache-0.12.3.tar.gz"
    sha256 "f528b27bf4d436b497a1d0d1a8f59a542c153ab1e37c3621713cb376d44c4713"
  end

  resource "aiorwlock" do
    url "https://files.pythonhosted.org/packages/c5/bf/d1ddcd676be027a963b3b01fdf9915daf4590b4dfd03bf1c8c2858aac7e3/aiorwlock-1.5.0.tar.gz"
    sha256 "b529da24da659bdedcf68faf216595bde00db228c905197ac554773620e7fd2f"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/13/7d/8bca2bf9a247c2c5dfeec1d7a5f40db6518f88d314b8bca9da29670d2671/aiosqlite-0.21.0.tar.gz"
    sha256 "131bb8056daa3bc875608c631c678cda73922a2d4ba8aec373b19f18c17e7aa3"
  end

  resource "alembic" do
    url "https://files.pythonhosted.org/packages/4a/ed/901044acb892caa5604bf818d2da9ab0df94ef606c6059fdf367894ebf60/alembic-1.15.1.tar.gz"
    sha256 "e1a1c738577bca1f27e68728c910cd389b9a92152ff91d902da649c192e30c49"
  end

  resource "alembic-postgresql-enum" do
    url "https://files.pythonhosted.org/packages/f9/45/d3a66a8c7604baba5b498727539539120897fd8f931a6c89aa68ff0d7cb3/alembic_postgresql_enum-1.7.0.tar.gz"
    sha256 "1a12a2b25f3f49440f419821888530496511573875438b6e9a08cbcb8a6f006f"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a3/73/199a98fc2dae33535d6b8e8e6ec01f8c1d76c9adb096c6b7d64823038cde/anyio-4.8.0.tar.gz"
    sha256 "1d9fe889df5212298c0c0723fa20479d1b94883a2df44bd3897aa91083316f7a"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/4e/00/6d6814ddc19be2df62c8c898c4df6b5b1914f3bd024b780028caa392d186/apscheduler-3.11.0.tar.gz"
    sha256 "4c622d250b0955a65d5d0eb91c33e6d43fd879834bf541e0a18661ae60460133"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/ee/be/29abccb5d9f61a92886a2fba2ac22bf74326b5c4f55d36d0a56094630589/argcomplete-3.6.0.tar.gz"
    sha256 "2e4e42ec0ba2fff54b0d244d0b1623e86057673e57bafe72dda59c64bd5dee8b"
  end

  resource "asyncpg" do
    url "https://files.pythonhosted.org/packages/2f/4c/7c991e080e106d854809030d8584e15b2e996e26f16aee6d757e387bc17d/asyncpg-0.30.0.tar.gz"
    sha256 "c551e9928ab6707602f44811817f82ba3c446e018bfe1d3abecc8ba5f3eac851"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/49/7c/fdf464bcc51d23881d110abd74b512a42b3d5d376a55a831b44c603ae17f/attrs-25.1.0.tar.gz"
    sha256 "1c97078a80c814273a76b2a298a932eb681c87415c11dee0a6921de7f1b02c3e"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/cc/ee/668328306a9e963a5ad9f152cd98c7adad86c822729fd1d2a01613ad1e67/azure_core-1.32.0.tar.gz"
    sha256 "22b3c35d6b2dae14990f6c1be2912bf23ffe50b220e708a28ab1bb92b1c730e5"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/ee/89/7d170fab0b85d9650cdb7abda087e849644beb52bd28f6804620dd0cecd9/azure_identity-1.20.0.tar.gz"
    sha256 "40597210d56c83e15031b0fe2ea3b26420189e1e7f3e20bdbb292315da1ba014"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/fe/3f/72e09a6f9a12d8afed8f56c929e8e142de21be9c19c27e4b2b94d60eb73a/azure_mgmt_compute-34.0.0.tar.gz"
    sha256 "58cd01d025efa02870b84dbfb69834a3b23501a135658c03854d2434e8dfee1e"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/48/9a/9bdc35295a16fe9139a1f99c13d9915563cbc4f30b479efaa40f8694eaf7/azure_mgmt_core-1.5.0.tar.gz"
    sha256 "380ae3dfa3639f4a5c246a7db7ed2d08374e88230fd0da3eb899f7c11e5c441a"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/bf/aa/bf464fd70eefa8f13f5e5b45d021416d5c9c8d79eabb96f4a673fe91346d/azure_mgmt_network-27.0.0.tar.gz"
    sha256 "5c1c61d8bb13ad40f788a26fd7569c1d9d60eb2e4cb19c2a1b5d9c02ae862316"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/a7/28/e950da2d89e55e2315ff0f4de075da4ac0fed4c27a489f7c774dedde9854/azure_mgmt_resource-23.3.0.tar.gz"
    sha256 "fc4f1fd8b6aad23f8af4ed1f913df5f5c92df117449dc354fea6802a2829fea4"
  end

  resource "azure-mgmt-subscription" do
    url "https://files.pythonhosted.org/packages/84/67/14b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1/azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/bb/5d/6d7433e0f3cd46ce0b43cd65e1db465ea024dbb8216fb2404e919c2ad77b/bcrypt-4.3.0.tar.gz"
    sha256 "3a3fd2204178b6d2adcf09cb4f6426ffef54762577a7c9b54c159008cb288c18"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/6b/e6/40f8c1fb52c02adad1c104c4c4ac0488bf8f2b1397f24db07779322e420b/boto3-1.37.7.tar.gz"
    sha256 "ac2e022edcd6a94a2adbb21f0ad373a16557ec14a8910366bee0bbc7138fc72a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/53/4b/096b2fac3ba92ace94f69f238eea9948af568b487c3898e9a8881bfe506b/botocore-1.37.7.tar.gz"
    sha256 "2faeac11766db912bc444669b04359080b7b83b2f57a3906c77c8105b70ce1e8"
  end

  resource "cached-classproperty" do
    url "https://files.pythonhosted.org/packages/6f/00/6c75d528e795555d65de8a4cd181347a5918d267c278478aeba2b369769b/cached_classproperty-1.0.1.tar.gz"
    sha256 "24ac50911c5a87bd57fafc348ce14ba58584975e73d1dfea329d1dcdc9f774c0"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/6c/81/3747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5/cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "cursor" do
    url "https://files.pythonhosted.org/packages/59/1b/ae231e1f9a8e1f970453f92fcb20a3fce87fa38753915477c26bc1655d86/cursor-1.3.5.tar.gz"
    sha256 "6758cae6ac14765ec85d9ce3f14fcb98fff5045f06d8398f1e8da8ce3acd2f20"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/b5/28/c5d26e5860df807241909a961a37d45e10533acef95fc368066c7dd186cd/fastapi-0.115.11.tar.gz"
    sha256 "cc81f03f688678b92600a65a5e618b93592c65005db37157147204d8924bf94f"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/dc/9c/0b15fb47b464e1b663b1acd1253a062aa5feecb07d4e597daea542ebd2b5/filelock-3.17.0.tar.gz"
    sha256 "ee4e77401ef576ebb38cd7f13b9b28893194acc20a8e68e18730ba9c0e54660e"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c0/89/37df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14/gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/b8/b7/481c83223d7b4f02c7651713fceca648fa3336e1571b9804713f66bca2d8/google_api_core-2.24.1.tar.gz"
    sha256 "f8b36f5456ab0dd99a1b693a40a31d1e7757beea380ad1b38faaf8941eae9d8a"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/29/9f/535346bb1469ec91139c38f0438ad70bd229a6b11452367065fe49303860/google_api_python_client-2.163.0.tar.gz"
    sha256 "88dee87553a2d82176e2224648bf89272d536c8f04dcdda37ef0a71473886dd7"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/c6/eb/d504ba1daf190af6b204a9d4714d457462b486043744901a6eeea711f913/google_auth-2.38.0.tar.gz"
    sha256 "8285113607d3b80a3f1543b75962447ba8a09fe85783432a784fdeef6ac094c4"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/32/5f/91891f39bfb79ab135a9ed7dfd2f632f6bb6bb93d31004605e4fcf44c55f/google_cloud_appengine_logging-1.6.0.tar.gz"
    sha256 "2f6ef52dfa88eca3bea078bc3c2b55ea61ff08b5e0c37912027fbb2a5f2d91ce"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/eb/81/c345efe9261a4b0bd0c5957f1685d2b4cc4522ec4fc7b0861f691d4476e7/google_cloud_audit_log-0.3.0.tar.gz"
    sha256 "901428b257020d8c1d1133e0fa004164a555e5a395c7ca3cdbb8486513df3a65"
  end

  resource "google-cloud-billing" do
    url "https://files.pythonhosted.org/packages/76/2b/0e361ca0b3f2461efc35d2b942ab0105894e24f6626751d37eddb86cbcb1/google_cloud_billing-1.16.1.tar.gz"
    sha256 "87da1c342f114aa14eb03222b5e3c53759d4b225d173e8c1e5467b868f4311a0"
  end

  resource "google-cloud-compute" do
    url "https://files.pythonhosted.org/packages/c8/59/a578bc41767fc68ea064fe94cdef78083f33054de594aa06a5619a1359ac/google_cloud_compute-1.26.0.tar.gz"
    sha256 "65b6c791060ac83cb8532f9336bd7e1458b06a155963b562b9b44e33eccd3030"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/8d/96/16cc0a34f75899ace6a42bb4ef242ac4aa263089b018d1c18c007d1fd8f2/google_cloud_core-2.4.2.tar.gz"
    sha256 "a4fcb0e2fcfd4bfe963837fad6d10943754fd79c1a50097d68540b6eb3d67f35"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/da/df/967f9c8aed155c999df11659b2fe05beedf789965d3b2eba682a3ae84628/google_cloud_logging-3.11.4.tar.gz"
    sha256 "32305d989323f3c58603044e2ac5d9cf23e9465ede511bbe90b4309270d3195c"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/f3/08/52143124415a889bbab60a8ecede1e31ea0e8d992ca078317886f26dc3be/google_cloud_storage-3.1.0.tar.gz"
    sha256 "944273179897c7c8a07ee15f2e6466a02da0c7c4b9ecceac2a26017cb2972049"
  end

  resource "google-cloud-tpu" do
    url "https://files.pythonhosted.org/packages/ba/af/d97af195c63f7b92b5574d2b7c397c5dc51462763bb145c37d52746a2851/google_cloud_tpu-1.23.0.tar.gz"
    sha256 "ae869b1b717f76158bde7327b219df9a9052a3617061239fd772660793456cfd"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/67/72/c3298da1a3773102359c5a78f20dae8925f5ea876e37354415f68594a6fb/google_crc32c-1.6.0.tar.gz"
    sha256 "6eceb6ad197656a1ff49ebfbbfa870678c75be4344feb35ac1edf694309413dc"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/58/5a/0efdc02665dca14e0837b62c8a1a93132c264bd02054a15abb2218afe0ae/google_resumable_media-2.7.2.tar.gz"
    sha256 "5280aed4629f2b60b847b0d42f9857fd4935c11af266744df33d8074cae92fe0"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/c2/92/6bb11dad062ad7cc40665d0a8986193d54f1a0032b510e84e7182df9e661/googleapis_common_protos-1.69.0.tar.gz"
    sha256 "5a46d58af72846f59009b9c4710425b9af2139555c71837081706b213b298187"
  end

  resource "gpuhunt" do
    url "https://files.pythonhosted.org/packages/f4/a5/38b4a1016b4efd62c554d7fb64ecd3deca98eeca8d117d41905704a70fd7/gpuhunt-0.1.0.tar.gz"
    sha256 "808586929db98ecbcd9abc581b2878f79197a8cacc687800996a3e3a569b091e"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/2f/ff/df5fede753cc10f6a5be0931204ea30c35fa2f2ea7a35b25bdaf4fe40e46/greenlet-3.1.1.tar.gz"
    sha256 "4ce3ac6cdb6adf7946475d7ef31777c26d94bccc377e070a7986bd2d5c515467"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/55/bc/310df38bfb67a5504d37dfcc370afd478cd8ccbf207057dd6f68e2e6350d/grpc_google_iam_v1-0.14.1.tar.gz"
    sha256 "14149f37af0e5779fa8a22a8ae588663269e8a479d9c2e69a5056e589bf8a891"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/69/e1/4b21b5017c33f3600dcc32b802bb48fe44a4d36d6c066f52650c7c2690fa/grpcio-1.70.0.tar.gz"
    sha256 "8d1584a68d5922330025881e63a6c1b54cc8117291d382e4fa69339b6d914c56"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/4c/d1/2397797c810020eac424e1aac10fbdc5edb6b9b4ad6617e0ed53ca907653/grpcio_status-1.70.0.tar.gz"
    sha256 "0e7b42816512433b18b9d764285ff029bde059e9d41f8fe10a60631bd8348101"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/6a/41/d7d0a89eb493922c37d343b607bc1b5da7f5be7e383740b4753ad8943e90/httpcore-1.0.7.tar.gz"
    sha256 "8551cb62a169ec7162ac7be8d4817d561f60e08eaa485234898414bb5a8a0b4c"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/cd/12/33e59336dca5be0c398a7482335911a33aa0e20776128f038019f1a95f1b/importlib_metadata-8.5.0.tar.gz"
    sha256 "71522656f0abace1d072b9e5481a48f07c138e00f079c38c8f883823f9c26bd7"
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
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/62/4f/ddb1965901bc388958db9f0c991255b2c469349a741ae8c9cd8a562d70a6/mako-1.3.9.tar.gz"
    sha256 "b5d65ff3462870feec922dbccf38f6efb44e5714d7b593a656be86663d8600ac"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/3f/f3/cdf2681e83a73c3355883c2884b6ff2f2d2aadfc399c28e9ac4edc3994fd/msal-1.31.1.tar.gz"
    sha256 "11b5e6a3f802ffd3a72107203e20c4eac6ef53401961b880af2835b723d80578"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/2d/38/ad49272d0a5af95f7a0cb64a79bbd75c9c187f3b789385a143d8d537a5eb/msal_extensions-1.2.0.tar.gz"
    sha256 "6f41b320bfd2933d631a215c91ca0dd3e67d84bd1a2f50ce917d5874ec646bef"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/2b/6d/bbbf879826b7f3c89a45252010b5796fb1f1a0d45d9dc4709db0ef9a06c8/opentelemetry_api-1.30.0.tar.gz"
    sha256 "375893400c1435bf623f7dfb3bcd44825fe6b56c34d0667c542ea8257b1a1240"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/7d/15/ad6ce226e8138315f2451c2aeea985bf35ee910afb477bae7477dc3a8f3b/paramiko-3.5.1.tar.gz"
    sha256 "b2c665bc45b2b215bd7d7f039901b14b067da00f3a11e6640995fd58f2664822"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/ed/d3/c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4/portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/62/14/7d0f567991f3a9af8d1cd4f619040c93b68f09a02b6d0b6ab1b2d1ded5fe/prometheus_client-0.21.1.tar.gz"
    sha256 "252505a722ac04b0456be05c05f75f45d760c2911ffc45f2a06bcaed9f3ae3fb"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/26/79/a5c6cbb42268cfd3ddc652dc526889044a8798c688a03ff58e5e92b743c8/proto_plus-1.26.0.tar.gz"
    sha256 "6e93d5f5ca267b54300880fff156b6a3386b3fa3f43b1da62e680fc0c586ef22"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/f7/d1/e0a911544ca9993e0f17ce6d3cc0932752356c1b0a834397f28e63479344/protobuf-5.29.3.tar.gz"
    sha256 "5da0f41edaf117bde316404bad1a486cb4ededf8e4a54891296f648e8e076620"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/1d/67/6afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9/pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/c3/e9/d99a2c4f8f6d7c711f39f6ecf485b7f3bba66189bbbad505d24eb0106922/pydantic-1.10.21.tar.gz"
    sha256 "64b48e2b609a6c22178a56c408ee1215a7206077ecb8a193e2fda31858b2362a"
  end

  resource "pydantic-duality" do
    url "https://files.pythonhosted.org/packages/9e/64/da9e9525f68803d75dca8b693097c666e53f2268cddaa51d6ec2335fe331/pydantic_duality-1.2.4.tar.gz"
    sha256 "34bdbf102c004f009619c2b6682143fa6f14c04bf947f0ba72d75b04e84a65c7"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8b/1a/3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2/pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dxf" do
    url "https://files.pythonhosted.org/packages/cc/f6/aac11aa8d64d39706838d57ace0b5ba5c31af157019e96c1bf2a8930563d/python_dxf-12.1.0.tar.gz"
    sha256 "59ff22c0ab92a29fb3085f65ea70c0e8c7ff9fdfd74db0109efd5dfdc404d96c"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/e3/c4/358cd13daa1d912ef795010897a483ab2f0b41c9ea1b35235a8b2f7d15a7/python_json_logger-3.2.1.tar.gz"
    sha256 "8eb0554ea17cb75b05d2848bc14fb02fbdbd9d6972120781b974380bfa162008"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/f3/87/f44d7c9f274c7ee665a29b885ec97089ec5dc034c7f3fafa03da9e39a09e/python_multipart-0.0.20.tar.gz"
    sha256 "8dd0cab45b8e23064ae09147625994d090fa46f5b0d1e13af944c331a7fa9d13"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/aa/b9/ff53663ee7fa6a4195fa96d91da499f2e00ca067541e016d345cce1c9ad2/rich_argparse-1.7.0.tar.gz"
    sha256 "f31d809c465ee43f367d599ccaf88b73bc2c4d75d74ed43f2d538838c53544ba"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/0a/79/2ce611b18c4fd83d9e3aecb5cba93e1917c050f556db39842889fa69b79f/rpds_py-0.23.1.tar.gz"
    sha256 "7f3240dcfa14d198dba24b8b9cb3b108c06b68d45b7babd9eefc1038fdf7e707"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/0f/ec/aa1a215e5c126fe5decbee2e107468f51d9ce190b9763cb649f76bb45938/s3transfer-0.11.4.tar.gz"
    sha256 "559f161658e1cf0a911f45940552c696735f5c74e64362e515f333ebed87d679"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/81/b6/662988ecd2345bf6c3a5c306a9a3590852742eff91d0a78a143398b816f3/sentry_sdk-2.22.0.tar.gz"
    sha256 "b4bf43bb38f547c84b2eadcefbe389b36ef75f3f38253d7a74d6b928c07ae944"
  end

  resource "simple-term-menu" do
    url "https://files.pythonhosted.org/packages/d8/80/f0f10b4045628645a841d3d98b584a8699005ee03a211fc7c45f6c6f0e99/simple_term_menu-1.6.6.tar.gz"
    sha256 "9813d36f5749d62d200a5599b1ec88469c71378312adc084c00c00bfbb383893"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/e4/08/9a90962ea72acd532bda71249a626344d855c4032603924b1b547694b837/sqlalchemy-2.0.38.tar.gz"
    sha256 "e5a4d82bdb4bf1ac1285a68eab02d253ab73355d9f0fe725a97e1e0fa689decb"
  end

  resource "sqlalchemy-utils" do
    url "https://files.pythonhosted.org/packages/4d/bf/abfd5474cdd89ddd36dbbde9c6efba16bfa7f5448913eba946fed14729da/SQLAlchemy-Utils-0.41.2.tar.gz"
    sha256 "bc599c8c3b3319e53ce6c5c3c471120bd325d0071fb6f38a10e924e3d07b9990"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/44/b6/fb9a32e3c5d59b1e383c357534c63c2d3caa6f25bf3c59dd89d296ecbaec/starlette-0.46.0.tar.gz"
    sha256 "b359e4567456b28d473d0193f34c0de0ed49710d75ef183a74a5ce0499324f50"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/4b/4d/938bd85e5bf2edeec766267a5015ad969730bb91e31b44021dfe8b22df6c/uvicorn-0.34.0.tar.gz"
    sha256 "404051050cd7e905de2c9a7e61790943440b3416f49cb409f965d9dcd0fa73e9"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/f5/26/c705fc77d0a9ecdb9b66f1e2976d95b81df3cae518967431e7dbf9b5e219/watchfiles-1.0.4.tar.gz"
    sha256 "6ba473efd11062d73e4f00c2b730255f9c1bdd73cd5f9fe5b5da8dbd4a717205"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "www-authenticate" do
    url "https://files.pythonhosted.org/packages/a7/2d/5567291a8274ef5d9b6495a1ec341394ab68933e2396936755b157f87b43/www-authenticate-0.9.2.tar.gz"
    sha256 "cf75fc2ea5effb0f9342d7de7619b736f2a7d4b223331a53e296863a286e9dcb"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    expected = "No default project, specify project name"
    assert_match expected, shell_output("#{bin}/dstack init 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/dstack --version")
  end
end
