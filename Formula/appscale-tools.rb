class AppscaleTools < Formula
  desc "Command-line tools for working with AppScale"
  homepage "https://github.com/AppScale/appscale-tools"
  url "https://github.com/AppScale/appscale-tools/archive/3.5.3.tar.gz"
  sha256 "ae3f373626d5d88d38cf17fef8bd5faaf92234bc6421d5f5c49cf5788acbe93a"
  head "https://github.com/AppScale/appscale-tools.git"

  bottle do
    cellar :any
    sha256 "4f41b03465b1dea26010f87ca4aae2685b58d50cc1139b17aed9b74da6e75fc7" => :mojave
    sha256 "09504e42c3fa49bef72caec812e751b662a64bc9c82b8e6489fee22eeda5f5f2" => :high_sierra
    sha256 "99ffa7564f5c791bff75392877e57c8ba513c95ab7ec98f18b3b68096faacf04" => :sierra
    sha256 "fb7096134ec7fd4172c3906190f123f21d8cf9c336729c07271f792e926997d3" => :el_capitan
  end

  depends_on "libyaml"
  depends_on "openssl"
  depends_on "python@2"
  depends_on "ssh-copy-id"

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/44/ef/beae4b4ef80902f22e3af073397f079c96969c69b2c7d52a57ea9ae61c9d/retrying-1.3.3.tar.gz"
    sha256 "08c039560a6da2fe4f2c426d0766e284d3b736e355f8dd24b37367b0bb41973b"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "SOAPpy" do
    url "https://files.pythonhosted.org/packages/78/1b/29cbe26b2b98804d65e934925ced9810883bdda9eacba3f993ad60bfe271/SOAPpy-0.12.22.zip"
    sha256 "e70845906bb625144ae6a8df4534d66d84431ff8e21835d7b401ec6d8eb447a5"
  end

  # Dependencies for SOAPpy
  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "wstools" do
    url "https://files.pythonhosted.org/packages/81/a3/0fbea78bccec0970032b847135b0d6050224c8601460464edcc748c5a22c/wstools-0.4.3.tar.gz"
    sha256 "578b53e98bc8dadf5a55dfd1f559fd9b37a594609f1883f23e8646d2d30336f8"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/74/ba/4ba4e89e21b5a2e267d80736ea674609a0a33cc4435a6d748ef04f1f9374/defusedxml-0.5.0.tar.gz"
    sha256 "24d7f2f94f7f3cb6061acb215685e5125fbcdc40a857eff9de22518820b0a4f4"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/66/e7/fe1db6a5ed53831b53b8a6695a8f134a58833cadb5f2740802bc3730ac15/boto-2.48.0.tar.gz"
    sha256 "deb8925b734b109679e3de65856018996338758f4b916ff4fe7bb62b6d7000d1"
  end

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/31/c4/c77f3ddadf17d041f237615d5fba02faefd93adfb82ad75877156647491a/google-api-python-client-1.5.4.tar.gz"
    sha256 "b9f6697cf9d2d556e8241c18518f1f9a2531e71b59703d0d1505bb47e97009ac"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/cd/db/f7b98cdc3f81513fb25d3cbe2501d621882ee81150b745cdd1363278c10a/uritemplate-3.0.0.tar.gz"
    sha256 "c02643cebe23fc8adb5e6becffe201185bf06c40bda5c0b4028a93f1527d011d"
  end

  # Dependencies for google-api-python-client
  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/c2/ce/7aaf19d8b856191e2e1885201fe45f3dc57b97f5ec5bc98ef2cc15472918/oauth2client-4.0.0.tar.gz"
    sha256 "80be5420889694634b8517b4acd3292ace881d9d1aa9d590d37ec52faec238c7"
  end

  # Dependencies for oauth2client
  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/eb/3d/b7d0fdf4a882e26674c68c20f40682491377c4db1439870f5b6f862f76ed/pyasn1-0.4.2.tar.gz"
    sha256 "d258b0a71994f7770599835249cece1caef3c70def868c4915e6e5ca49b67d15"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/ab/76/36ab0e099e6bd27ed95b70c2c86c326d3affa59b9b535c63a2f892ac9f45/pyasn1-modules-0.2.1.tar.gz"
    sha256 "af00ea8f2022b6287dc375b2c70f31ab5af83989fc6fe9eacd4976ce26cd7ccc"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/14/89/adf8b72371e37f3ca69c6cb8ab6319d009c4a24b04a31399e5bd77d9bb57/rsa-3.4.2.tar.gz"
    sha256 "25df4e10c263fb88b5ace923dd84bf9aa7f5019687b5e55382ffcdb8bede9db5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/e4/2e/a7e27d2c36076efeb8c0e519758968b20389adf57a9ce3af139891af2696/httplib2-0.10.3.tar.gz"
    sha256 "e404d3b7bd86c1bc931906098e7c1305d6a3a6dcef141b8bb1059903abb3ceeb"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/1c/a1/3367581782ce79b727954f7aa5d29e6a439dc2490a9ac0e7ea0a7115435d/tabulate-0.7.7.tar.gz"
    sha256 "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/dc/8c/7c9869454bdc53e72fb87ace63eac39336879eef6f2bf96e946edbf03e90/setuptools-33.1.1.zip"
    sha256 "6b20352ed60ba08c43b3611bdb502286f7a869fbfcf472f40d7279f1e77de145"
  end

  # Dependencies for Azure
  resource "azure-mgmt-nspkg" do
    url "https://files.pythonhosted.org/packages/fe/66/66eb0d5ead69b7371649466fa160a166de0d1ddafc4a1d7a172858a8abc9/azure-mgmt-nspkg-2.0.0.zip"
    sha256 "e36488d4f5d7d668ef5cc3e6e86f081448fd60c9bf4e051d06ff7cfc5a653e6f"
  end

  resource "azure-nspkg" do
    url "https://files.pythonhosted.org/packages/06/a2/77820fa07ec4657d6456b67edfa78856b4789ada42d1bb8e8485df19824e/azure-nspkg-2.0.0.zip"
    sha256 "fe19ee5d8c66ee8ef62557fc7310f59cffb7230f0a94701eef79f6e3191fdc7b"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/00/39/7b915a03e1a64415c81a8b8f317556182592327d2b62812ef2b19e71b378/azure-common-1.1.4.zip"
    sha256 "f8c8d97d0a7de202a47d7081c39c0e4a827c78900719d02c2ebe936e44ff152f"
  end

  resource "azure-servicemanagement-legacy" do
    url "https://files.pythonhosted.org/packages/71/72/247d6e15711ace1e0e680d067f34e04facb3bc4b340234c0267b54842b01/azure-servicemanagement-legacy-0.20.4.zip"
    sha256 "742df8756065ff033d9af974851d2de6df5cc09de53802cf3172646c1e7f2932"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/1f/9e/7b2ff7e965fc654592269f2906ade1c7d705f1bf25b7d469fa153f7d19eb/futures-3.2.0.tar.gz"
    sha256 "9ec02aa7d674acb8618afb127e27fde7fc68994c0437ad759fa094a574adb265"
  end

  resource "azure-storage" do
    url "https://files.pythonhosted.org/packages/94/fd/301d5d72126125b59731ad64bcfcc9bc75fcddb9bb8370a917559a693433/azure-storage-0.33.0.zip"
    sha256 "1117e15bdd699b7f44412fec06948b9161de13c0cd01bea092c7752112542c40"
  end

  resource "azure-servicebus" do
    url "https://files.pythonhosted.org/packages/38/97/a0f9a44d2c9501329338ae252794c12939e70188a41d902c2717f26f7385/azure-servicebus-0.20.3.zip"
    sha256 "442bf44d32286cdaef71f75e03bcff912a7111f281462b9c4d560f77687684f7"
  end

  resource "azure-batch" do
    url "https://files.pythonhosted.org/packages/2a/e9/6c16410251d9e65e89a8f72f6c5bcb3b8b54928a072e9481eccebd9c1cd4/azure-batch-1.0.0.zip"
    sha256 "0c863b863f9efa1ff1a30c4a8aa6d8bb6c80b334bb01de43ae863daefb982e3e"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/f8/d8/425dc59243cca1e907778445d68610345fda4ff341b12209d4d4bb3d1388/azure-mgmt-storage-0.30.0rc6.zip"
    sha256 "8038669aa1386e6def927accf4b0d0426a5a542fcce71fed4c5100aff9d55a65"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/5a/88/12b179f4473b51b671a126741b4520edbfea164bf0d683d3a0c78cec98a9/azure-mgmt-resource-0.30.0rc6.zip"
    sha256 "afc26ac7c0a468c04504e63f3d361ead4bdedc7e48fd41197779396423ed7383"
  end

  resource "azure-mgmt-batch" do
    url "https://files.pythonhosted.org/packages/14/15/315e59a9a3c7db95c9d653cec963d6dbb935a11335b5679aecf229d600f5/azure-mgmt-batch-1.0.0.zip"
    sha256 "3af7750aff8ccacaf73ec482bfa5c5c7ea57ca1fa9c51541da6564d91583e5eb"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/7d/b5/e85d7054f2ef45f4413e6711837d5dc3ac85ac3114cf3891e8938ecc40d5/azure-mgmt-compute-0.30.0rc6.zip"
    sha256 "01ec076790dc7ac509a753f2492e82776e9a0ae1556608fbc86d7b646f348d77"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/11/d8/bf649497dc0e589920393f6a3b9be3bec7eeea38c1f41d4476a5e828585b/azure-mgmt-keyvault-0.30.0rc6.zip"
    sha256 "c01e9a62cbce0889e5030653ecc99a9ff240dfd2858f666837a3247eb2c2a19a"
  end

  resource "azure-mgmt-logic" do
    url "https://files.pythonhosted.org/packages/9f/16/32ef7f8cae08a7d2c7bd096c5d9f3af2fd96de23d3f8db337333401d8b36/azure-mgmt-logic-1.0.0.zip"
    sha256 "12efc80bcab1a6e5f7a641e3873c7dfbd8ecbcba49f7c222cd04a26d196f6007"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/60/54/1459f5652fe19da9689bf8642f84fe220f6307dac8ac2a62e2b9f582eaa2/azure-mgmt-network-0.30.0rc6.zip"
    sha256 "31b1849d470adf2189f47f8de84f0875b0ccbbc5de576cdbbd8500a1ef95870f"
  end

  resource "azure-mgmt-scheduler" do
    url "https://files.pythonhosted.org/packages/d2/42/4b15b354a2208e1fa43c327fd5a3215071140467624d3a14d97076988d7d/azure-mgmt-scheduler-1.0.0.zip"
    sha256 "bddf4b9ee5a27180782831a375604b2af0cff0c0cbd5e57a010cc4f0c6a322c3"
  end

  resource "azure-mgmt-redis" do
    url "https://files.pythonhosted.org/packages/47/bc/b42afac6ff6479c95d8d5a0946f0c94f818a2cecb84303482eecf0d41f40/azure-mgmt-redis-1.0.0.zip"
    sha256 "b5c1de56e66756134ede1757901d4c3ece62e7dcc16c21f4d7c3c7ca0e27dbad"
  end

  resource "azure-mgmt" do
    url "https://files.pythonhosted.org/packages/52/4a/1812c3d233e3d2e62613337552be64022dc4b231a5d51e25266cc68ddb33/azure-mgmt-0.30.0rc6.zip"
    sha256 "b3b0c187bcc51bbcd49b8254921d70a8988d733a7c822a533ec7ec762ccfb9b8"
  end

  resource "azure" do
    url "https://files.pythonhosted.org/packages/85/5c/d4a19612a2ca66966267198cd238ecc5e99e2082a41f0344733c7302ca92/azure-2.0.0rc6.zip"
    sha256 "d71fa18a2f8f3e6d56051782e00497d28414a68219b01899ba3f791bcd6bd324"
  end

  # Dependencies for cryptography
  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/f0/ba/860a4a3e283456d6b7e2ab39ce5cf11a3490ee1a363652ac50abf9f0f5df/ipaddress-1.0.19.tar.gz"
    sha256 "200d8686011d470b5e4de207d803445deee427455cd0cb7c982b68cf82524f81"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/78/c5/7188f15a92413096c93053d5304718e1f6ba88b818357d05d19250ebff85/cryptography-2.1.4.tar.gz"
    sha256 "e4d967371c5b6b2e67855066471d844c5d52d210c36c28d49a8507b96e2c5291"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/e5/1d/64a3b1c30842ecf0518af93ed123e5064559e588aebdcae0a59831dee642/python-dateutil-2.7.0.tar.gz"
    sha256 "8f95bb7e6edbb2456a51a1fb58c8dca942024b4f5844cae62c90aa88afe6e300"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/0e/01/021a7cd3f898e8fcba2cda40b3cc07c0f957ae1ede394559643e20656468/PyJWT-1.6.0.tar.gz"
    sha256 "9c3016e4a292151c5396e25cc0c28c4e1cdf13fa19118eb84f500f9670e3f628"
  end

  resource "adal" do
    url "https://files.pythonhosted.org/packages/dd/55/fe57a0c94680f7b72bb524c085d28a0e407dcaa695ab927d1a904fdc7b6a/adal-0.4.5.tar.gz"
    sha256 "c5ddfd473fe272ae1deefcee22f99f094f9f195bcb52a8678b2e315b755fe253"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/3b/15/a5d90ab1a41075e8f0fae334f13452549528f82142b3b9d0c9d86ab7178c/pyOpenSSL-17.5.0.tar.gz"
    sha256 "2c10cfba46a52c0b0950118981d61e72c1e5b1aac451ca1bc77de1a679456773"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/72/46/4abc3f5aaf7bf16a52206bb0c68677a26c216c1e6625c78c5aef695b5359/requests-2.14.2.tar.gz"
    sha256 "a274abba399a23e8713ffd2b5706535ae280ebe2b8069ee6a941cb089440d153"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/5e/f8/ac0b545c716ed7bab54d11669328e34a6f1eb4a5d8b188d443a7b234861f/keyring-11.0.0.tar.gz"
    sha256 "b4607520a7c97be96be4ddc00f4b9dac65f47a45af4b4cd13ed5a8879641d646"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/6a/d1/761e69540cc8076a8a64f280638397e2eb1dcba1ff697e5cd1730797eff9/msrestazure-0.4.19.tar.gz"
    sha256 "43b78f25a432772b48c1dee615bd2c1de2ebb2f8107e96d4eea8cf6f691069c4"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/15/d4/2f888fc463d516ff7bf2379a4e9a552fef7f22a94147655d9b1097108248/certifi-2018.1.18.tar.gz"
    sha256 "edbc3f203427eef571f79a7692bb160a2b0f7ccaa31953e99bd17e307cf63f7d"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/a5/8a/212e9b47fb54be109f3ff0684165bb38c51117f34e175c379fce5c7df754/oauthlib-2.0.6.tar.gz"
    sha256 "ce57b501e906ff4f614e71c36a3ab9eacbb96d35c24d1970d2539bbc3ec70ce1"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5/requests-oauthlib-0.8.0.tar.gz"
    sha256 "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/e5/51/5c57754bfb2c097f5057c11a712d7b45f9a7f78191085085d3f34c809c4f/msrest-0.4.27.tar.gz"
    sha256 "cf45f02d73e45e5382f0e03b7552f530b090547cf77c4fb19f7dbe1990b3a739"
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
