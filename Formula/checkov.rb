class Checkov < Formula
  include Language::Python::Virtualenv

  desc "Prevent cloud misconfigurations during build-time for IaC tools"
  homepage "https://www.checkov.io/"
  # checkov should only be updated every 15 releases on multiples of 15
  url "https://files.pythonhosted.org/packages/d8/31/2972c35085d7da8e9c1749a2fac8a31f255b7b5bce6a12f7646cfd3513be/checkov-2.0.270.tar.gz"
  sha256 "71bab42f93ac323ebdc2992684505c9797bfe44392d1b61735678ad77bb3cef9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a5b05a2a3fbda3e4e4a2c0137831d2d090348e9ef0163c700991690cb3e006f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "667056e8e8c4f8c64d5eb8c136675367c192a00c2e903f421c0d3cc983182017"
    sha256 cellar: :any_skip_relocation, catalina:      "490ff0acdf4b01edace700c0338ff15fd9c6dc7b04d9a459f9329aa91f491cf4"
    sha256 cellar: :any_skip_relocation, mojave:        "2e86330e5161a17c71c79eca1066e5c226fce17e893b9bb4bfee8d1fea17dac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76ef262015123aecf32155fac4722a358350f0190f8dfe72be147ef1af44431d"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "bc-python-hcl2" do
    url "https://files.pythonhosted.org/packages/88/3b/864cc7c4793ec8874a02f293d40f36371b6dbcff414e108a72c95069fd79/bc-python-hcl2-0.3.18.tar.gz"
    sha256 "768c1a3c00db3cb9be7bd1e08c20813cf1e86d4a3cc47a76f7f97172d7b7d432"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/6b/c3/d31704ae558dcca862e4ee8e8388f357af6c9d9acb0cad4ba0fbbd350d9a/beautifulsoup4-4.9.3.tar.gz"
    sha256 "84729e322ad1d5b4d25f805bfa05b902dd96450f43842c4e99067d5e1369eb25"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/7b/4d/3ee45c9afebcb44d0009b709e8590267669ef5bbd1310de9ccc179cb2c17/boto3-1.17.112.tar.gz"
    sha256 "08b6dacbe7ebe57ae8acfb7106b2728d946ae1e0c3da270caee1deb79ccbd8af"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/4d/c8/2d47e502c12d4b436e5b865cc78552604888aee59570c12b1863bb09c11b/botocore-1.20.112.tar.gz"
    sha256 "d0b9b70b6eb5b65bb7162da2aaf04b6b086b15cc7ea322ddc3ef2f5e07944dcf"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e1/e6/707ff774274c66f1db739ff4d7eb493252899ed86f0018ac3e9e462fe3de/charset-normalizer-2.0.2.tar.gz"
    sha256 "951567c2f7433a70ab63f1be67e5ee05d3925d9423306ecb71a3b272757bcc95"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/3c/86/5de6d909d9dcc85627a178788ec3e8c3ef81cda175badb48ad0bb582628d/click-option-group-0.5.3.tar.gz"
    sha256 "a6e924f3c46b657feb5b72679f7e930f8e5b224b766ab35c91ae4019b4e0615e"
  end

  resource "cloudsplaining" do
    url "https://files.pythonhosted.org/packages/d5/46/0c0d16ca82a549991e7d4de63ee6ba6ee7c08a872fe55fc6714e224f79f0/cloudsplaining-0.4.3.tar.gz"
    sha256 "b3c1897ff7d741f7d244e26bc4bf145d16b46b2131d8058211012b077a545a25"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/d9/ad/d82750ad3a9e3419425eeeef7fbb5c8381dc8ec64a9894ddc3854837b10f/ConfigArgParse-1.5.1.tar.gz"
    sha256 "371f46577e76ec71a183b88378f36dd09f4b946f60fe60712f411b020f26b812"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/c7/13/37ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8f/contextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "Cycler" do
    url "https://files.pythonhosted.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "deep_merge" do
    url "https://files.pythonhosted.org/packages/a5/25/aa35c20acd8a4f515f9e4c8dee4c7731446234101a6dae0c34cf498bb342/deep_merge-0.0.4.tar.gz"
    sha256 "b54415f90934c42e334114e2864cb4d4e7335b34ad396e35ad8610c96065a47e"
  end

  resource "detect-secrets" do
    url "https://files.pythonhosted.org/packages/fc/79/c5d0c23c552934ba6305a30817652b4c17686cc20d9bd4f762480199b1fb/detect_secrets-1.1.0.tar.gz"
    sha256 "68250b31bc108f665f05f0ecfb34f92423280e48e65adbb887fdf721ed909627"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/fa/a2/e46d7c1b51394a09271a3b07c3a68deb3a669429beafd444d9553ed52868/docker-5.0.0.tar.gz"
    sha256 "3e8bc47534e0ca9331d72c32f2881bb13b93ded0bcdeab3c833fb7cf61c0a9a5"
  end

  resource "dockerfile-parse" do
    url "https://files.pythonhosted.org/packages/d0/f6/8eb044e3837f6da0a85d9f73158104fecdab68bc86a83625b1e398963ed3/dockerfile-parse-1.2.0.tar.gz"
    sha256 "07e65eec313978e877da819855870b3ae47f3fac94a40a965b9ede10484dacc5"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/88/b2/abc5803f37a2ea1045d68765acfcb4ec166bc9e08c3ba451c53af29a73f2/dpath-1.5.0.tar.gz"
    sha256 "496615b4ea84236d18e0d286122de74869a60e0f87e2c7ec6787ff286c48361b"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/34/fe/9265459642ab6e29afe734479f94385870e8702e7f892270ed6e52dd15bf/gitdb-4.0.7.tar.gz"
    sha256 "96bf5c08b157a666fec41129e6d327235284cca4c81e92109260f353ba138005"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/29/22/3d591875078c1c5e7e11b478616821995053968a74b76043c55448c46381/GitPython-3.1.18.tar.gz"
    sha256 "b838a895977b45ab6f0cc926a9045c8d1c44e2b653c1fcc39fe91f42c6e8f05b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/39/11/8076571afd97303dfeb6e466f27187ca4970918d4b36d5326725514d3ed3/Jinja2-3.0.1.tar.gz"
    sha256 "703f484b47a6af502e743c9122595cc812b0271f661722403114f71a79d0f5a4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "junit-xml-2" do
    url "https://files.pythonhosted.org/packages/4d/f2/a99adf9deb57949b81ff8e113edf971da1840251794a6f4184d61faa5a65/junit-xml-2-1.9.tar.gz"
    sha256 "3b8d9635c5215f754c7807104f6493e3ea3bc9481e2d33db294560da3a1b00f7"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/90/55/399ab9f2e171047d28933ae4b686d9382d17e6c09a01bead4a6f6b5038f4/kiwisolver-1.3.1.tar.gz"
    sha256 "950a199911a8d94683a6b10321f9345d5a3a8433ec58b217ace979e18f16e248"
  end

  resource "lark-parser" do
    url "https://files.pythonhosted.org/packages/0d/a5/60580c84bbc28f3952aec8f718e7311eb679a825f9c1d424d98a5542d7c0/lark-parser-0.10.1.tar.gz"
    sha256 "42f367612a1bbc4cf9d8c8eb1b209d8a9b397d55af75620c9e6f53e502235996"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/49/02/37bd82ae255bb4dfef97a4b32d95906187b7a7a74970761fca1360c4ba22/Markdown-3.3.4.tar.gz"
    sha256 "31b5b491868dcc87d6c24b7e3d19a0d730d59d3e46f4eea6430a321bed387a49"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/60/d3/286925802edaeb0b8834425ad97c9564ff679eb4208a184533969aa5fc29/matplotlib-3.4.2.tar.gz"
    sha256 "d8d994cefdff9aaba45166eb3de4f5211adb4accac85cbf97137e98f26ea0219"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/b0/21/adfbf6168631e28577e4af9eb9f26d75fe72b2bb1d33762a5f2c425e6c2a/networkx-2.5.1.tar.gz"
    sha256 "109cd585cac41297f71103c3c42ac6ef7379f29788eb54cb751be5a663bb235a"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/66/03/818876390c7ff4484d5a05398a618cfdaf0a2b9abb3a7c7ccd59fe181008/numpy-1.21.0.zip"
    sha256 "e80fe25cba41c124d04c662f33f6364909b985f2eb5998aaa5ae4b9587242cce"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/53/05/bf382e8bc60731906a2e7261648bcea3a6b309ad2b9952010737a1b9413e/pandas-1.3.0.tar.gz"
    sha256 "c554e6c9cf2d5ea1aba5979cc837b3649539ced0e18ece186f055450c86622e2"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/8f/7d/1e9c2d8989c209edfd10f878da1af956059a1caab498e5bc34fa11b83f71/Pillow-8.3.1.tar.gz"
    sha256 "2cac53839bfc5cece8fdbe7f084d5e3ee61e1303cccc86511d351adcb9e2c792"
  end

  resource "policy-sentry" do
    url "https://files.pythonhosted.org/packages/2b/40/96773da0a8ecad688bd2b870c21dfa6949cda6cbfffafa9935e7d462cd28/policy_sentry-0.11.10.tar.gz"
    sha256 "2c3e4405a72f8284f7a3c987fbd666b3ae63fd095101e004e9ee6a1fb1ab76ff"
  end

  resource "policyuniverse" do
    url "https://files.pythonhosted.org/packages/88/ce/e96ca9ddf8e62388b7de23c6ac511bcdbe0c2028782ce901dda88f4a7762/policyuniverse-1.3.8.20210714.tar.gz"
    sha256 "c559cb71781513626db21caf2b849a325bc23ac47f15c713d649d7300b0f7189"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/27/90/f467e516a845cf378d85f0a51913c642e31e2570eb64b352c4dc4c6cbfc7/s3transfer-0.4.2.tar.gz"
    sha256 "cb022f4b16551edebbb31a377d3f09600dbada7363d8c5db7976e7f47732e1b2"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/2b/91/42bc143289fd5f032ab1b01c5da32dc162ae808a585122f27ed5bf67268f/schema-0.7.4.tar.gz"
    sha256 "fbb6a52eb2d9facf292f233adcc6008cffd94343c63ccac9a1cb1f3e6de1db17"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/bb/bb/944f559d554df6c9adf037aa9fc982a9706ee0e96c0d5beac701cb158900/scipy-1.7.0.tar.gz"
    sha256 "998c5e6ea649489302de2c0bc026ed34284f531df89d2bdc8df3a0d44d165739"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/d4/52/3be868c7ed1f408cb822bc92ce17ffe4e97d11c42caafce0589f05844dd0/semantic_version-2.8.5.tar.gz"
    sha256 "d2cb2de0558762934679b9a104e82eca7af448c9f4974d1f3eeccff651df8a54"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/dd/d4/2b4f196171674109f0fbb3951b8beab06cd0453c1b247ec0c4556d06648d/smmap-4.0.0.tar.gz"
    sha256 "7e65386bd122d45405ddf795637b7f7d2b532e7e401d46bbe3fb49b9986d5182"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/c8/3f/e71d92e90771ac2d69986aa0e81cf0dfda6271e8483698f4847b861dd449/soupsieve-2.2.1.tar.gz"
    sha256 "052774848f448cf19c7e959adf5566904d525f33a3f8b6ba6f6f8f26ec7de0cc"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/dd/78f7e080d3bfc87fc19bed54513b430659d38efb2d9ea6e3ad815a665a02/tqdm-4.61.2.tar.gz"
    sha256 "8bb94db0d4468fea27d004a0f1d1c02da3cdedc00fe491c0de986b76a04d6b0a"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/aa/55/62e2d4934c282a60b4243a950c9dbfa01ae7cac0e8d6c0b5315b87432c81/typing_extensions-3.10.0.0.tar.gz"
    sha256 "50b6f157849174217d0656f99dc82fe932884fb250826c18350e159ec6cdf342"
  end

  resource "update-checker" do
    url "https://files.pythonhosted.org/packages/5c/0b/1bec4a6cc60d33ce93d11a7bcf1aeffc7ad0aa114986073411be31395c6f/update_checker-0.18.0.tar.gz"
    sha256 "6a2d45bb4ac585884a6b03f9eade9161cedd9e8111545141e9aa9058932acb13"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/58/0d/af54f4732115a20c370f43f179523d189a5cb75711c60ba00b41e163a065/websocket-client-1.1.0.tar.gz"
    sha256 "b68e4959d704768fa20e35c9d508c8dc2bbc041fd8d267c0d7345cffe2824568"
  end

  def install
    inreplace "checkov/common/output/report.py", "junit_xml", "junit_xml_2"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.tf").write <<~EOS
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    EOS

    assert_match "Passed checks: 4, Failed checks: 5, Skipped checks: 0",
      shell_output("#{bin}/checkov -f #{testpath}/test.tf 2>&1", 1)

    (testpath/"test2.tf").write <<~EOS
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        #checkov:skip=CKV_AWS_52
        #checkov:skip=CKV_AWS_20:The bucket is a public static content host
        versioning {
          enabled = true
        }
      }
    EOS
    assert_match "Passed checks: 4, Failed checks: 4, Skipped checks: 1",
      shell_output("#{bin}/checkov -f #{testpath}/test2.tf 2>&1", 1)
  end
end
