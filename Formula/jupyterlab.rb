class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/a2/5c/c209190ba2a6dac3937d91f2610f5eee9a29b7f05f5a66bb7058e83e730b/jupyterlab-3.0.0.tar.gz"
  sha256 "15228dff3f77b0bca795fd232cb25f02121510cec83f1d25856b3bc8e585b087"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "92e45c85e6570c24c1a5536749c98f6ba8df93a719b881151ecae0416d159641" => :big_sur
    sha256 "7eebb721052e86f8a0620ed44a0329e7a31bf692bdad0439ae5b300a6ec80661" => :catalina
    sha256 "0093ea4638abd24d1bf9fb5ef2a1a865df4f7b49e5344a744d3980f5d304d274" => :mojave
  end

  depends_on "ipython"
  depends_on "node"
  depends_on "pandoc"
  depends_on "python@3.9"
  depends_on "zeromq"

  uses_from_macos "expect" => :test

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/db/7c/c25052956b882c226adcad815197f32dde4eb9dfbbd19041b291811b1032/anyio-2.0.2.tar.gz"
    sha256 "35075abd32cf20fd7e0be2fee3614e80b92d5392eba257c8d2f33de3df7ca237"
  end

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/e9/bc/2d2c567fe5ac1924f35df879dbf529dd7e7cabd94745dc9d89024a934e76/appnope-0.1.2.tar.gz"
    sha256 "dd83cd4b5b460958838f6eb3000c660b1f9caf2a5b1de4264e941512f603258a"
  end

  resource "argon2-cffi" do
    url "https://files.pythonhosted.org/packages/74/fd/d78e003a79c453e8454197092fce9d1c6099445b7e7da0b04eb4fe1dbab7/argon2-cffi-20.1.0.tar.gz"
    sha256 "d8029b2d3e4b4cea770e9e5a0104dd8fa185c1724a0f01528ae4826a6d25f97d"
  end

  resource "async_generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"
    sha256 "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/41/1b/5ed6e564b9ca54318df20ebe5d642ab25da4118df3c178247b8c4b26fa13/Babel-2.9.0.tar.gz"
    sha256 "da031ab54472314f210b0adcff1588ee5d1d1d0ba4dbd07b94dba82bde791e05"
  end

  resource "backcall" do
    url "https://files.pythonhosted.org/packages/a2/40/764a663805d84deee23043e1426a9175567db89c8b3287b5c2ad9f71aa93/backcall-0.2.0.tar.gz"
    sha256 "5cbdbf27be5e7cfadb448baf0aa95508f91f2bbc6c6437cd9cd06e2a4c215e1e"
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/04/2c/8e256291cfeaefb72d1dafc888b1ad447e754d8062520b41f1d3ffa7e139/bleach-3.2.1.tar.gz"
    sha256 "52b5919b81842b1854196eaae5ca29679a2f2e378905c346d3ca8227c2c66080"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/66/6a/98e023b3d11537a5521902ac6b50db470c826c682be6a8c661549cb7717a/cffi-1.14.4.tar.gz"
    sha256 "1a465cbe98a7fd391d47dce4b8f7e5b921e6cd805ef421d04f5f66ba8f06086c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/da/93/84fa12f2dc341f8cf5f022ee09e109961055749df2d0c75c5f98746cfe6c/decorator-4.4.2.tar.gz"
    sha256 "e3a62f0520172440ca0dcc823749319382e377f37f140a0b99ef45fecb84bfe7"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/a4/5f/f8aa58ca0cf01cbcee728abc9d88bfeb74e95e6cb4334cfd5bed5673ea77/defusedxml-0.6.0.tar.gz"
    sha256 "f684034d135af4c6cbb949b8a4d2ed61634515257a67299e5f940fbaa34377f5"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c/entrypoints-0.3.tar.gz"
    sha256 "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/9d/e7/8a9f328bdf5d2325d7e5d2e3097138f91a4971ccb245fa430752ca61c9a7/ipykernel-5.4.2.tar.gz"
    sha256 "e20ceb7e52cb4d250452e1230be76e0b2323f33bd46c6b2bc7abb6601740e182"
  end

  resource "ipython" do
    url "https://files.pythonhosted.org/packages/cf/65/1224bc51f155ebf098eaeef02bb7fdeb380b2e03986b626d1811921db16f/ipython-7.19.0.tar.gz"
    sha256 "cbb2ef3d5961d44e6a963b9817d4ea4e1fa2eb589c371a470fed14d8d40cbd6a"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/39/67/50d1653038dafe06ca2cc55c4598c5f8318d519c12a7a288d7826280ee22/jedi-0.17.2.tar.gz"
    sha256 "86ed7d9b750603e4ba582ea8edc678657fb4007894a12bcf6f4bb97892f31d20"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c/Jinja2-2.11.2.tar.gz"
    sha256 "89aab215427ef59c34ad58735269eb58b1a5808103067f7bb9d5836c651b3bb0"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/8d/b4/d09c00cb7bc88b17118be48f94d4b8d0ce7b572690625ca2b5477e05ce0e/json5-0.9.5.tar.gz"
    sha256 "703cfee540790576b56a92e1c6aaa6c4b0d98971dc358ead83812aa4d06bdb96"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/c3/7a/53e652fb8cbca92ae5f325cbd8b2ba123b57fbc1cc5e8a47ad1c62d75e93/jupyter_client-6.1.7.tar.gz"
    sha256 "49e390b36fe4b4226724704ea28d9fb903f1a3601b6882ce3105221cd09377a1"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/46/54/aa5d2ec9aad97d696970c1f64f36fc82c14057734d3c8cfa2e0c79f114fb/jupyter_core-4.7.0.tar.gz"
    sha256 "aa1f9496ab3abe72da4efe0daab0cb2233997914581f9a071e07498c6add8ed3"
  end

  resource "jupyter-server" do
    url "https://files.pythonhosted.org/packages/d1/3d/db398fe096d71f2fa9838ec6d7970eddc40f22c048ec35430bcf8363f66f/jupyter_server-1.1.3.tar.gz"
    sha256 "23ce959718592ba472db7982a5daf15dda3397fd50bb54d05ad10c09fe122905"
  end

  resource "jupyterlab-pygments" do
    url "https://files.pythonhosted.org/packages/d1/79/3677d138eeacbba7cf6d0e51e6b8c094448329f7b8a523a5d2599bc898e7/jupyterlab_pygments-0.1.2.tar.gz"
    sha256 "cfcda0873626150932f438eccf0f8bf22bfa92345b814890ab360d666b254146"
  end

  resource "jupyterlab-server" do
    url "https://files.pythonhosted.org/packages/30/ae/414e265f15b8cbc199255b13c93becf39e5509ff0bb3cee024526c2cf69d/jupyterlab_server-2.0.0.tar.gz"
    sha256 "1350c36954d3d16c71129b30b60b9df11e8fcf2f3acf88596f6abc8a79b0c918"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/2d/a4/509f6e7783ddd35482feda27bc7f72e65b5e7dc910eca4ab2164daf9c577/mistune-0.8.4.tar.gz"
    sha256 "59a3429db53c50b5c6bcc8a07f8848cb00d7dc8bdb431a4ab41920d201d4756e"
  end

  resource "nbclassic" do
    url "https://files.pythonhosted.org/packages/7f/bb/8934730affc5a155d39766c15f92317484e16d011030420d09f2626127b9/nbclassic-0.2.5.tar.gz"
    sha256 "e6da2116ab76a63de62f42cf8ea93c9a0c564aaf8315834f7c52efb85b4640ab"
  end

  resource "nbclient" do
    url "https://files.pythonhosted.org/packages/21/bf/8bc77713fe0e5c9255233f112cd5819d692a4eded7922e40d82970ce5616/nbclient-0.5.1.tar.gz"
    sha256 "01e2d726d16eaf2cde6db74a87e2451453547e8832d142f73f72fddcd4fe0250"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/8b/93/d2b263036424da6bde39fddc768e6d725830c181b86fd83cb4fa5c653993/nbconvert-6.0.7.tar.gz"
    sha256 "cbbc13a86dfbd4d1b5dee106539de0795b4db156c894c2c5dc382062bbc29002"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/ad/6c/ab9715323ed5c0893f619788e5c0a452c42fce4a42c032245eae2c2fa31d/nbformat-5.0.8.tar.gz"
    sha256 "f545b22138865bfbcc6b1ffe89ed5a2b8e2dc5d4fe876f2ca60d8e6f702a30f8"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/a7/e0/6125c2b7e64ce7c55a45f5b1dffe97bc5643945139374a80963c7b1308e6/nest_asyncio-1.4.3.tar.gz"
    sha256 "eaa09ef1353ebefae19162ad423eef7a12166bcc63866f8bff8f3635353cd9fa"
  end

  resource "notebook" do
    url "https://files.pythonhosted.org/packages/84/99/5c73a5d9b4743b25e2fc53a76050838f9c46834e7fe702be8d3b0c3affb7/notebook-6.1.6.tar.gz"
    sha256 "cf40d4f81541401db5a2fda1707ca7877157abd41f04ef7b88f02b67f3c61791"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/c5/e81b9fb8033fe78a2355ea7b1774338e1dca2c9cbd2ee140211a9e6291ab/packaging-20.8.tar.gz"
    sha256 "78598185a7008a470d64526a8059de9aaa449238f280fc9eb6b13ba6c4109093"
  end

  resource "pandocfilters" do
    url "https://files.pythonhosted.org/packages/28/78/bd59a9adb72fa139b1c9c186e6f65aebee52375a747e4b6a6dcf0880956f/pandocfilters-1.4.3.tar.gz"
    sha256 "bc63fbb50534b4b1f8ebe1860889289e8af94a23bff7445259592df25a3906eb"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/40/01/e0b8d2168fb299af90a78a5919257f821e5c21399bf0906c14c9e573db3f/parso-0.7.1.tar.gz"
    sha256 "caba44724b994a8a5e086460bb212abc5a8bc46951bf4a9a1210745953622eb9"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "pickleshare" do
    url "https://files.pythonhosted.org/packages/d8/b6/df3c1c9b616e9c0edbc4fbab6ddd09df9535849c64ba51fcb6531c32d4d8/pickleshare-0.7.5.tar.gz"
    sha256 "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/18/9a/958cc52225370c9c7f66f4cea04250923db683d70fb2f45ba6f5f96169be/prometheus_client-0.9.0.tar.gz"
    sha256 "9da7b32f02439d8c04f7777021c304ed51d9ec180604700c1ba72a4d44dceb03"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/d4/12/7fe77b49d67845a378cfadb484b64218ed09d0e8bf420c663b4fe28f0631/prompt_toolkit-3.0.8.tar.gz"
    sha256 "25c95d2ac813909f813c93fde734b6e44406d1477a9faef7c915ff37d39c0a8c"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/7d/2d/e4b8733cf79b7309d84c9081a4ab558c89d8c89da5961bf4ddb050ca1ce0/ptyprocess-0.6.0.tar.gz"
    sha256 "923f299cc5ad920c68f2bc0bc98b75b9f838b93b599941a6b63ddbc2476394c0"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/29/60/8ff9dcb5eac7f4da327ba9ecb74e1ad783b2d32423c06ef599e48c79b1e1/Pygments-2.7.3.tar.gz"
    sha256 "ccf3acacf3782cbed4a989426012f1c535c9a90d3a7fc3f16d231b9372d2b716"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/4d/70/fd441df751ba8b620e03fd2d2d9ca902103119616f0f6cc42e6405035062/pyrsistent-0.17.3.tar.gz"
    sha256 "2e636185d9eb976a18a8a8e96efce62f2905fea90041958d8cc2a189756ebf3e"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/09/07/448a8887c7195450604dfc0305d80d74324c36ee18ed997664051d4bffe3/pytz-2020.4.tar.gz"
    sha256 "3e6b7dd2d1e0a59084bcee14a17af60c5c562cdc16d828e8eba2e683d3a7e268"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/15/81/009a2cd08bc5de6ed092c94508b45d6dbc6f6d0bbeddbe14d36b51f28216/pyzmq-20.0.0.tar.gz"
    sha256 "824ad5888331aadeac772bce27e1c2fbcab82fade92edbd234542c4e12f0dca9"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "Send2Trash" do
    url "https://files.pythonhosted.org/packages/13/2e/ea40de0304bb1dc4eb309de90aeec39871b9b7c4bd30f1a3cdcb3496f5c0/Send2Trash-1.5.0.tar.gz"
    sha256 "60001cc07d707fe247c94f74ca6ac0d3255aabcb930529690897ca2a39db28b2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "terminado" do
    url "https://files.pythonhosted.org/packages/24/87/ab5f5bb7e51f5bca46aeee902e216b144e503e93f317c98e2dfebbae1445/terminado-0.9.1.tar.gz"
    sha256 "3da72a155b807b01c9e8a5babd214e052a0a45a975751da3521a1c3381ce6d76"
  end

  resource "testpath" do
    url "https://files.pythonhosted.org/packages/2c/b3/5d57205e896d8998d77ad12aa42ebce75cd97d8b9a97d00ba078c4c9ffeb/testpath-0.4.4.tar.gz"
    sha256 "60e0a3261c149755f4399a1fff7d37523179a70fdc3abdf78de9fc2604aeec7e"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/cf/44/cc9590db23758ee7906d40cacff06c02a21c2a6166602e095a56cbf2f6f6/tornado-6.1.tar.gz"
    sha256 "33c6e81d7bd55b468d2e793517c909b139960b6c790a60b7991b9b6b76fb9791"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/b8/24/e6dfe45ecfc4c2b0d6774565e631dc1b9e50de2c3536625d377963d56cae/traitlets-5.0.5.tar.gz"
    sha256 "178f4ce988f69189f7e523337a3e11d91c786ded9360174a3d9ca83e79bc5396"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/29/e6/d1a1d78c439cad688757b70f26c50a53332167c364edb0134cadd280e234/urllib3-1.26.2.tar.gz"
    sha256 "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
    ENV["JUPYTER_PATH"] = etc/"jupyter"

    # gather packages to link based on options
    linked = %w[jupyter-core jupyter-client nbformat ipykernel jupyter-console nbconvert notebook]
    dependencies = resources.map(&:name).to_set - linked
    dependencies.each do |r|
      venv.pip_install resource(r)
    end
    venv.pip_install_and_link linked
    venv.pip_install_and_link buildpath

    # remove bundled kernel
    rm_rf Dir["#{libexec}/share/jupyter/kernels"]

    # install completion
    resource("jupyter-core").stage do
      bash_completion.install "examples/jupyter-completion.bash" => "jupyter"
      zsh_completion.install "examples/completions-zsh" => "_jupyter"
    end
  end

  def caveats
    <<~EOS
      Additional kernels can be installed into the shared jupyter directory
        #{etc}/jupyter
    EOS
  end

  test do
    system bin/"jupyter-console --help"
    assert_match "python3", shell_output("#{bin}/jupyter kernelspec list")

    (testpath/"console.exp").write <<~EOS
      spawn #{bin}/jupyter-console
      expect "In "
      send "exit\r"
    EOS
    assert_match "Jupyter console", shell_output("expect -f console.exp")

    (testpath/"notebook.exp").write <<~EOS
      spawn #{bin}/jupyter-notebook --no-browser
      expect "NotebookApp"
    EOS
    assert_match "NotebookApp", shell_output("expect -f notebook.exp")

    (testpath/"nbconvert.ipynb").write <<~EOS
      {
        "cells": []
      }
    EOS
    system bin/"jupyter-nbconvert", "nbconvert.ipynb", "--to", "html"
    assert_predicate testpath/"nbconvert.html", :exist?, "Failed to export HTML"

    assert_match "-F _jupyter",
      shell_output("source #{bash_completion}/jupyter && complete -p jupyter")

    version_regexp = Regexp.quote(version.to_s)

    # Ensure that jupyter can load the jupyter lab package.
    assert_match /^jupyter lab *: #{version_regexp}$/,
      shell_output(bin/"jupyter --version")

    # Ensure that jupyter-lab binary was installed by pip.
    assert_match /^#{version_regexp}$/,
      shell_output(bin/"jupyter-lab --version")
  end
end
