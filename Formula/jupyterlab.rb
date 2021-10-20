class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/21/41/9fa76ba01f776c267ead5ea7224cb179e38e02d37690b4f9e0a1475a807e/jupyterlab-3.1.14.tar.gz"
  sha256 "13174cb6076dd5da6f1b85725ccfcc9518d8f98e86b8b644fc89b1dfaeda63a9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0abd979a17d0cc585c29af4af791784b6da20bb7b5c6b07a51f0645f5d1d56d4"
    sha256 cellar: :any,                 big_sur:       "956891642a710eb82573069cc116ded9a496540c828e3c666b1dd082a05dbd6b"
    sha256 cellar: :any,                 catalina:      "13f4fc45af9bc41d98430b2fe7d1815fe32abcfc329c4785854e88f1e84eee82"
    sha256 cellar: :any,                 mojave:        "c88e5f22e4fcfb159f3028fdafb6d777d3d7bb23f54ca17ba3d9624884673078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f85d00b4d30ce35e0f860a44a05994d1409448cbbdd8ab947fd081b997ee0be4"
  end

  depends_on "node"
  depends_on "pandoc"
  depends_on "python@3.9"
  depends_on "six"
  depends_on "zeromq"

  uses_from_macos "expect" => :test

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/bf/3f/4d9972a2190759ac2a576c8fa8b64102a11932ccfb10ed928a116e283f5c/anyio-3.3.2.tar.gz"
    sha256 "0b993a2ef6c1dc456815c2b5ca2819f382f20af98087cc2090a4afed3a501436"
  end

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/e9/bc/2d2c567fe5ac1924f35df879dbf529dd7e7cabd94745dc9d89024a934e76/appnope-0.1.2.tar.gz"
    sha256 "dd83cd4b5b460958838f6eb3000c660b1f9caf2a5b1de4264e941512f603258a"
  end

  resource "argon2-cffi" do
    url "https://files.pythonhosted.org/packages/7b/39/a26aaef5c3f0c6cfd67c80599b5b40a794fdab46f4ee3be925d71e2f9596/argon2-cffi-21.1.0.tar.gz"
    sha256 "f710b61103d1a1f692ca3ecbd1373e28aa5e545ac625ba067ff2feca1b2bb870"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/17/e6/ec9aa6ac3d00c383a5731cc97ed7c619d3996232c977bb8326bcbb6c687e/Babel-2.9.1.tar.gz"
    sha256 "bc0c176f9f6a994582230df350aa6e05ba2ebe4b3ac317eab29d9be5d2768da0"
  end

  resource "backcall" do
    url "https://files.pythonhosted.org/packages/a2/40/764a663805d84deee23043e1426a9175567db89c8b3287b5c2ad9f71aa93/backcall-0.2.0.tar.gz"
    sha256 "5cbdbf27be5e7cfadb448baf0aa95508f91f2bbc6c6437cd9cd06e2a4c215e1e"
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/6a/a3/217842324374fd3fb33db0eb4c2909ccf3ecc5a94f458088ac68581f8314/bleach-4.1.0.tar.gz"
    sha256 "0900d8b37eba61a802ee40ac0061f8c2b5dee29c1927dd1d233e075ebf5a71da"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2e/92/87bb61538d7e60da8a7ec247dc048f7671afe17016cd0008b3b710012804/cffi-1.14.6.tar.gz"
    sha256 "c9a875ce9d7fe32887784274dd533c57909b7b1dcadcc128a2ac21331a9765dd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/eb/7f/a6c278746ddbd7094b019b08d1b2187101b1f596f35f81dc27f57d8fcf7c/charset-normalizer-2.0.6.tar.gz"
    sha256 "5ec46d183433dcbd0ab716f2d7f29d8dee50505b3fdb40c6b985c7c4f5a3591f"
  end

  resource "debugpy" do
    url "https://files.pythonhosted.org/packages/30/46/ed7311c871dff926770deb8c7370a26d58d9340e1130012a2bc570d31f72/debugpy-1.4.3.zip"
    sha256 "4d53fe5aecf03ba466aa7fa7474c2b2fe28b2a6c0d36688d1e29382bfe88dd5f"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/92/3c/34f8448b61809968052882b830f7d8d9a8e1c07048f70deb039ae599f73c/decorator-5.1.0.tar.gz"
    sha256 "e59913af105b9860aa2c8d3272d9de5a56a4e608db9a2f167a8480b323d529a7"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c/entrypoints-0.3.tar.gz"
    sha256 "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/4f/fe/2e411e2f2fba2318957e34694867e9d9b63811cd1aecff25984f31e35de0/ipykernel-6.4.1.tar.gz"
    sha256 "df3355e5eec23126bc89767a676c5f0abfc7f4c3497d118c592b83b316e8c0cd"
  end

  resource "ipython" do
    url "https://files.pythonhosted.org/packages/e2/c8/7046d0409a90e31263d5bbaa708347d522ac584a1140c01a951d9deb1792/ipython-7.28.0.tar.gz"
    sha256 "2097be5c814d1b974aea57673176a924c4c8c9583890e7a5f082f547b9975b11"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/ac/11/5c542bf206efbae974294a61febc61e09d74cb5d90d8488793909db92537/jedi-0.18.0.tar.gz"
    sha256 "92550a404bad8afed881a137ec9a461fed49eca661414be45059329614ed0707"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/39/11/8076571afd97303dfeb6e466f27187ca4970918d4b36d5326725514d3ed3/Jinja2-3.0.1.tar.gz"
    sha256 "703f484b47a6af502e743c9122595cc812b0271f661722403114f71a79d0f5a4"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/20/8c/66cde351ffff609a0bd7176e42f698781128bbcb3f28e00a6a857aa7af34/json5-0.9.6.tar.gz"
    sha256 "9175ad1bc248e22bb8d95a8e8d765958bf0008fef2fe8abab5bc04e0f1ac8302"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/9c/99/9789c7fd0bb8876a7d624d903195ce11e5618b421bdb1bf7c975d17a9bc3/jsonschema-4.0.0.tar.gz"
    sha256 "bc51325b929171791c42ebc1c70b9713eb134d3bb8ebd5474c8b659b15be6d86"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/d1/fa/e5e8b9c7cd3d2338431d92762d238383be8d5a80ca7834671ccd78e42b8a/jupyter_client-7.0.5.tar.gz"
    sha256 "382aca66dcaf96d7eaaa6c546d57cdf8b3b1cf5bc1f2704c58a1d8d244f1163d"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/bb/dc/bb0e8b5093582699271df99cad202390e5cfcdb6bc5e772ca2fa8f61ade6/jupyter_core-4.8.1.tar.gz"
    sha256 "ef210dcb4fca04de07f2ead4adf408776aca94d17151d6f750ad6ded0b91ea16"
  end

  resource "jupyter-server" do
    url "https://files.pythonhosted.org/packages/ed/0e/613b6e407dc3cdf82d14824915057bb176fa968e20d7e35c2e95f96d5842/jupyter_server-1.11.0.tar.gz"
    sha256 "8ab4f484a4a2698f757cff0769d27b5d991e0232a666d54f4d6ada4e6a61330b"
  end

  resource "jupyterlab-pygments" do
    url "https://files.pythonhosted.org/packages/d1/79/3677d138eeacbba7cf6d0e51e6b8c094448329f7b8a523a5d2599bc898e7/jupyterlab_pygments-0.1.2.tar.gz"
    sha256 "cfcda0873626150932f438eccf0f8bf22bfa92345b814890ab360d666b254146"
  end

  resource "jupyterlab-server" do
    url "https://files.pythonhosted.org/packages/79/41/552120becdd267b505f6aafc522c0d90bb051d780cd1b1e7429286b01418/jupyterlab_server-2.8.2.tar.gz"
    sha256 "26d813c8162c83d466df7d155865987dabe70aa452f9187dfb79fd88afc8fa0b"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "matplotlib-inline" do
    url "https://files.pythonhosted.org/packages/0f/98/838f4c57f7b2679eec038ad0abefd1acaeec35e635d4d7af215acd7d1bd2/matplotlib-inline-0.1.3.tar.gz"
    sha256 "a04bfba22e0d1395479f866853ec1ee28eea1485c1d69a6faf00dc3e24ff34ee"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/2d/a4/509f6e7783ddd35482feda27bc7f72e65b5e7dc910eca4ab2164daf9c577/mistune-0.8.4.tar.gz"
    sha256 "59a3429db53c50b5c6bcc8a07f8848cb00d7dc8bdb431a4ab41920d201d4756e"
  end

  resource "nbclassic" do
    url "https://files.pythonhosted.org/packages/97/89/1389edffd9dc896fc709207b308973a1dc37a6580e356951ea14249e938f/nbclassic-0.3.2.tar.gz"
    sha256 "863462bf6a6e0e5e502dcc479ce2ea1edf60437c969f1850d0c0823dba0c39b7"
  end

  resource "nbclient" do
    url "https://files.pythonhosted.org/packages/fc/be/c61d973ff6a53bfd961e81bfccf38d0bb7612546c247afeb27985430c593/nbclient-0.5.4.tar.gz"
    sha256 "6c8ad36a28edad4562580847f9f1636fe5316a51a323ed85a24a4ad37d4aefce"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/44/d0/10e2ac291002ae48491f674eb31cf8fc3b247a742d5426a51ff794ba32ca/nbconvert-6.2.0.tar.gz"
    sha256 "16ceecd0afaa8fd26c245fa32e2c52066c02f13aa73387fffafd84750baea863"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/e5/bd/847367dcc514b198936a3de8bfaeda1935e67ce369bf0b3e7f3ed4616ae8/nbformat-5.1.3.tar.gz"
    sha256 "b516788ad70771c6250977c1374fcca6edebe6126fd2adb5a69aa5c2356fd1c8"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/ad/82/2fdf6a92eed4ddf5e9d9a735d019af1ef3a56f084d9549972b2527a43a48/nest_asyncio-1.5.1.tar.gz"
    sha256 "afc5a1c515210a23c461932765691ad39e8eba6551c055ac8d5546e69250d0aa"
  end

  resource "notebook" do
    url "https://files.pythonhosted.org/packages/6c/f9/3d3756a76beb56e5b4e3a892383024fb5c157688efb8241af69786a20d8e/notebook-6.4.4.tar.gz"
    sha256 "26b0095c568e307a310fd78818ad8ebade4f00462dada4c0e34cbad632b9085d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "pandocfilters" do
    url "https://files.pythonhosted.org/packages/62/42/c32476b110a2d25277be875b82b5669f2cdda7897c165bd22b78f366b3cb/pandocfilters-1.5.0.tar.gz"
    sha256 "0b679503337d233b4339a817bfc8c50064e2eff681314376a47cb582305a7a38"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/5e/61/d119e2683138a934550e47fc8ec023eb7f11b194883e9085dca3af5d4951/parso-0.8.2.tar.gz"
    sha256 "12b83492c6239ce32ff5eed6d3639d6a536170723c6f3f1506869f1ace413398"
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
    url "https://files.pythonhosted.org/packages/a1/90/7f1a14c2d0638e1a6981612171881733ef015cbabbded709ac3ab3d2920a/prometheus_client-0.11.0.tar.gz"
    sha256 "3a8baade6cb80bcfe43297e33e7623f3118d660d41387593758e2fb1ea173a86"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/b4/56/9ab5868f34ab2657fba7e2192f41316252ab04edbbeb2a8583759960a1a7/prompt_toolkit-3.0.20.tar.gz"
    sha256 "eb71d5a6b72ce6db177af4a7d4d7085b99756bf656d98ffcc4fecd36850eea6c"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pydevd" do
    url "https://files.pythonhosted.org/packages/da/dc/63e24b9bf8a8ae0bae39e5eb8198d7add1b7e699be7919831e0931016db1/pydevd-2.5.0.tar.gz"
    sha256 "eb09d4e6667d63fcbfc777827e5d2cf702a314f8ff7d060d2d1e7d9e7e604dcf"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/f4/d7/0fa558c4fb00f15aabc6d42d365fcca7a15fcc1091cd0f5784a14f390b7f/pyrsistent-0.18.0.tar.gz"
    sha256 "773c781216f8c2900b42a7b638d5b517bb134ae1acbebe4d1e8f1f41ea60eb4b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/6c/95/d37e7db364d7f569e71068882b1848800f221c58026670e93a4c6d50efe7/pyzmq-22.3.0.tar.gz"
    sha256 "8eddc033e716f8c91c6a2112f0a8ebc5e00532b4a6ae1eb0ccc48e027f9c671c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/4d/ce/78b651fe0adbd4227578fa432d1bde03b4f4945a70c81e252a2b6a2d895f/requests-unixsocket-0.2.0.tar.gz"
    sha256 "9e5c1a20afc3cf786197ae59c79bcdb0e7565f218f27df5f891307ee8817c1ea"
  end

  resource "Send2Trash" do
    url "https://files.pythonhosted.org/packages/49/2c/d990b8d5a7378dde856f5a82e36ed9d6061b5f2d00f39dc4317acd9538b4/Send2Trash-1.8.0.tar.gz"
    sha256 "d2c24762fd3759860a0aff155e45871447ea58d2be6bdd39b5c8f966a0c99c2d"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "terminado" do
    url "https://files.pythonhosted.org/packages/7a/82/97a3b275b44b031eba1e27e136993464e670821aa4616a9dfaba0c2b4e8f/terminado-0.12.1.tar.gz"
    sha256 "b20fd93cc57c1678c799799d117874367cc07a3d2d55be95205b1a88fa08393f"
  end

  resource "testpath" do
    url "https://files.pythonhosted.org/packages/dd/bf/245f32010f761aaeff132278e91e0d0ae1c360d6f3708a11790fdc1410d2/testpath-0.5.0.tar.gz"
    sha256 "1acf7a0bcd3004ae8357409fc33751e16d37ccc650921da1094a86581ad1e417"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/cf/44/cc9590db23758ee7906d40cacff06c02a21c2a6166602e095a56cbf2f6f6/tornado-6.1.tar.gz"
    sha256 "33c6e81d7bd55b468d2e793517c909b139960b6c790a60b7991b9b6b76fb9791"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/d5/bc/37d490908e7ac949614d62767db3c86f37bc5adb6129d378c35859a75b87/traitlets-5.1.0.tar.gz"
    sha256 "bd382d7ea181fbbcce157c133db9a829ce06edffe097bcf3ab945b435452b46d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/4e/8f/b5c45af5a1def38b07c09a616be932ad49c35ebdc5e3cbf93966d7ed9750/websocket-client-1.2.1.tar.gz"
    sha256 "8dfb715d8a992f5712fff8c843adae94e22b22a99b2c5e6b0ec4a1a981cc4e0d"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
    ENV["JUPYTER_PATH"] = etc/"jupyter"

    # gather packages to link based on options
    linked = %w[jupyter-core jupyter-client nbformat ipykernel jupyter-console nbconvert notebook]
    dependencies = resources.map(&:name).to_set - linked
    dependencies -= ["appnope"] if OS.linux?
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

    pydevd_vendor_dir = libexec/Language::Python.site_packages("python3")/"debugpy/_vendored/pydevd"
    pydevd_vendor_dir.rmtree # remove pre-built binaries
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
      shell_output("bash -c \"source #{bash_completion}/jupyter && complete -p jupyter\"")

    # Ensure that jupyter can load the jupyter lab package.
    assert_match(/^jupyterlab *: #{version}$/,
      shell_output(bin/"jupyter --version"))

    # Ensure that jupyter-lab binary was installed by pip.
    assert_equal version.to_s,
      shell_output(bin/"jupyter-lab --version").strip

    port = free_port
    fork { exec "#{bin}/jupyter-lab", "-y", "--port=#{port}", "--no-browser", "--ip=127.0.0.1", "--LabApp.token=''" }
    sleep 10
    assert_match "<title>JupyterLab</title>",
      shell_output("curl --silent --fail http://localhost:#{port}/lab")
  end
end
