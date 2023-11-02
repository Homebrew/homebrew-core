class Prowler < Formula
  include Language::Python::Virtualenv

  desc "Open Source Security tool to perform Cloud Security best practices"
  homepage "https://prowler.pro/"
  url "https://files.pythonhosted.org/packages/26/0a/74c9c70f46d216f3ccc0d38a7f28d36c9eced66974e9709a23534c0ef1a5/prowler-3.11.0.tar.gz"
  sha256 "92caca36640171b4f32d577a6c2ef2d34d2bcaf0d274429d5ba7064041da7dd2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc381f18996e8a6267212be7f15af1e3fa482d878d4373b3b1bf47aa8a7eb2a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60f4d965e6b5f4ce1f52f886a76a6cff25a9040d10940a064ab5519ab5117670"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d380cf47b8f8d713cd281297e13479e62beb141c84043568c4c904475c6f122b"
    sha256 cellar: :any_skip_relocation, sonoma:         "59a602c97e1bea17adc80053b8c475d14ec8e49906d02a2ff23e9e9583424972"
    sha256 cellar: :any_skip_relocation, ventura:        "07eeacdf693d48e71e1e30e86d0cefcdd2fcb851e875afc769c8a98657d62583"
    sha256 cellar: :any_skip_relocation, monterey:       "fb8a7ef750b3ce1ea4f31e58ee56eb2048f86c31a9cca88c64fc29e3b5f8f04d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba30ef6f26653ac4bffbed619fa6f5b78ccfa0219dc4f6f1beacb3a4ab594a42"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python-pyparsing"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "about-time" do
    url "https://files.pythonhosted.org/packages/1c/3f/ccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0a/about-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "alive-progress" do
    url "https://files.pythonhosted.org/packages/ec/55/ae92dce431293998db7575fd2d8315d239d760772df39871b901d3f78357/alive-progress-3.1.4.tar.gz"
    sha256 "74a95d8d0d42bc99d3a3725dbd06ebb852245f1b64e301a7c375b92b22663f7b"
  end

  resource "awsipranges" do
    url "https://files.pythonhosted.org/packages/19/2e/6efa95f995369da828715f41705686cd214b9259ed758266942553d40441/awsipranges-0.3.3.tar.gz"
    sha256 "4f0b3f22a9dc1163c85b513bed812b6c92bdacd674e6a7b68252a3c25b99e2c0"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/e3/39/328faea9f656075dbb8ecf70f1a4697bc80510fcc70e3e8f0090c34fc00c/azure-core-1.29.5.tar.gz"
    sha256 "52983c89d394c6f881a121e5101c5fa67278ca3b1f339c8fb2ef39230c70e9ac"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/74/02/a0545eaa3fb83a6b6c413de4a65e06a02ce887f874a2e74a1240b2169140/azure-identity-1.15.0.tar.gz"
    sha256 "4c28fc246b7f9265610eb5261d65931183d019a23d4b0e99357facb2e6c227c8"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/14/95/2b2085e40f4b9de88ad256428a669583066d8ab348fc19110c7d04c3189b/azure-mgmt-core-1.4.0.zip"
    sha256 "d195208340094f98e5a6661b781cde6f6a051e79ce317caabd8ff97030a9b3ae"
  end

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/ee/ba/a3ac088d30e0179df32e0a4981e670e96138b6141d4be821ccfd9ea5951b/azure-mgmt-security-5.0.0.zip"
    sha256 "38b03efe82c2344cea203fda95e6d00b7ac22782fa1c0b585cd0ea2c8ff3e702"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/3f/af/398c57d15064ea23475076cd087b1a143b66d33a029e6e47c4688ca32310/azure-mgmt-sql-3.0.1.zip"
    sha256 "129042cc011225e27aee6ef2697d585fa5722e5d1aeb0038af6ad2451a285457"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/49/5c/9fc3418570dcb5de5f883f909b894f9cdd77829c84afb08b7370c796334e/azure-mgmt-storage-21.1.0.tar.gz"
    sha256 "d6d3c0e917c988bc9ed0472477d3ef3f90886009eb1d97a711944f8375630162"
  end

  resource "azure-mgmt-subscription" do
    url "https://files.pythonhosted.org/packages/84/67/14b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1/azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/9d/f5/4ec0b5b3a99f6a4bb5c82f8dbab121bcd892c355ae363140558a164cff08/azure-storage-blob-12.18.3.tar.gz"
    sha256 "d8ced0deee3367fa3d4f3d1a03cd9edadf4440c0a371f503d623fa6c807554ee"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/0f/3c/8a0b46a53326236006a4c4d1a0d49c4ff3a83368492c8308031fbaf61583/boto3-1.26.165.tar.gz"
    sha256 "9e7242b9059d937f34264125fecd844cb5e01acce6be093f6c44869fdf7c6e30"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/3d/f6/d35a27c73dc1053abdfe8524d1e488073fccb51e43c88da61b8fe29522e3/botocore-1.29.165.tar.gz"
    sha256 "988b948be685006b43c4bbd8f5c0cb93e77c66deb70561994e0c5b31b5a67210"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/10/21/1b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5/cachetools-5.3.2.tar.gz"
    sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/6d/b3/aa417b4e3ace24067f243e45cceaffc12dba6b8bd50c229b43b3b163768b/charset-normalizer-3.3.1.tar.gz"
    sha256 "d9137a876020661972ca6eec0766d81aef8a5627df628b664b234b73396e727e"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/c7/13/37ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8f/contextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "detect-secrets" do
    url "https://files.pythonhosted.org/packages/f1/55/292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31/detect_secrets-1.4.0.tar.gz"
    sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/3f/5d/9138d873205a38e5264a78fd4ebf446fc987f20e2566719ed6eee69c200a/google-api-core-2.12.0.tar.gz"
    sha256 "c22e01b1e3c4dcd90998494879612c38d0a3411d1f7b679eb89e2abe3ce1f553"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/03/75/7a04c88700a6c186bb7e9979c1b2b15d1944bf66453b778ea69e4efcccb6/google-api-python-client-2.105.0.tar.gz"
    sha256 "0a8b32cfc2d9b3c1868ae6faef7ee1ab9c89a6cec30be709ea9c97f9a3e5902d"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/45/71/0f19d6f51b6ea291fc8f179d152d675f49acf88cb44f743b37bf51ef2ec1/google-auth-2.23.3.tar.gz"
    sha256 "6864247895eea5d13b9c57c9e03abb49cb94ce2dc7c58e91cba3248c7477c9e3"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/0f/7a/83c3a1f8419d66f91672ad7f2cea57d044f7f0b3c1740389a468ff3937ed/google-auth-httplib2-0.1.1.tar.gz"
    sha256 "c64bc555fdc6dd788ea62ecf7bccffcf497bf77244887a3f3d7a5a02f8e3fc29"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/95/41/f9d4425eac5cec8c0356575b8f183e8f1f7206875b1e748bd3af4b4a8a1e/googleapis-common-protos-1.61.0.tar.gz"
    sha256 "8a64866a97f6304a7179873a465d6eee97b7a24ec6cfd78e0f575e96b821240b"
  end

  resource "grapheme" do
    url "https://files.pythonhosted.org/packages/ce/e7/bbaab0d2a33e07c8278910c1d0d8d4f3781293dfbc70b5c38197159046bf/grapheme-0.6.0.tar.gz"
    sha256 "44c2b9f21bbe77cfb05835fec230bd435954275267fea1858013b102f8603cca"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/5d/03/fa40e4a7c9bd32492ed5e222b23f699553f0d25ff8f7d489fcb21a745787/msal-1.24.1.tar.gz"
    sha256 "aa0972884b3c6fdec53d9a0bd15c12e5bd7b71ac1b66d746f54d128709f3f8f8"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/33/5e/2e23593c67df0b21ffb141c485ca0ae955569203d7ff5064040af968cb81/msal-extensions-1.0.0.tar.gz"
    sha256 "c676aba56b0cce3783de1b5c5ecfe828db998167875126ca4b47dc6436451354"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/35/94/e2a15b577044b6b0e4b610a26fcd4439863d8d21bda419e0fd24580316cd/msgraph-core-0.2.2.tar.gz"
    sha256 "147324246788abe8ed7e05534cd9e4e0ec98b33b30e011693b8d014cebf97f63"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/35/00/0f230921ba852226275762ea3974b87eeca36e941a13cd691ed296d279e5/portalocker-2.8.2.tar.gz"
    sha256 "2b035aa7828e46c58e9b31390ee1f169b98e1066ab10b9a6a861fe7e25ee4f33"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/52/5c/f2c0778278259089952f94b0884ca27a001a17ffbd992ebe30c841085f4c/protobuf-4.24.4.tar.gz"
    sha256 "5a70731910cd9104762161719c3d883c960151eea077134458503723b60e3667"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/51/cd/721eb771f3f09f60de0807e240c3acf44c38828d0ced869fe8df7e79801b/pydantic-1.10.13.tar.gz"
    sha256 "32c8b48dcd3b2ac4e78b0ba4af3a2c2eb6048cb75202f0ea7b34feb740efc340"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/30/72/8259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3b/PyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/50/5c/d32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019/requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/5a/47/d676353674e651910085e3537866f093d2b9e9699e95e89d960e78df9ecf/s3transfer-0.6.2.tar.gz"
    sha256 "cab66d3380cca3e70939ef2255d01cd8aece6a4907a9528740f668c4b0611861"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/4e/e8/01e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9/schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "shodan" do
    url "https://files.pythonhosted.org/packages/0c/b8/60c2a98f767fb991ba9452551639e8a43db9269af860feac259e636e0719/shodan-1.30.1.tar.gz"
    sha256 "bedb6e8c2b4459592c1bc17b4d4b57dab0cb58a455ad589ee26a6304242cd505"
  end

  resource "slack-sdk" do
    url "https://files.pythonhosted.org/packages/00/5a/727f4621be0aa175248fce6d183707ab782f23d0ed5351a1092f1ed11cdc/slack_sdk-3.23.0.tar.gz"
    sha256 "9d6ebc4ff74e7983e1b27dbdb0f2bb6fc3c2a2451694686eaa2be23bbb085a73"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/ed/41/0a06e38f7fb55a3a2abaf998e018ed7d22987c0f1abbbcc1d50e06975b4f/tldextract-5.0.1.tar.gz"
    sha256 "ac1c5daa02616e9c2608f5fb6dd93049db03d0cf46c7f6fad46e2850a984f019"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/0c/39/64487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08/urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/2b/a3/dd02e3559b2c785d2357c3752cc191d750a280ff3cb02fa7c2a8f87523c3/XlsxWriter-3.1.9.tar.gz"
    sha256 "de810bf328c6a4550f4ffd6b0b34972aeb7ffcf40f3d285a0413734f9b63a929"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ens_rd2022_aws", shell_output("#{bin}/prowler aws --list-compliance")
    assert_match "rds", shell_output("#{bin}/prowler aws --list-services")

    assert_match "NoCredentialsError[33]: Unable to locate credentials",
      shell_output("#{bin}/prowler aws --quick-inventory 2>&1", 1)

    assert_match "Prowler #{version}", shell_output("#{bin}/prowler -v")
  end
end
