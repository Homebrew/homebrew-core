class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/b1/64/fc16aed4f198251003b89b1a06a979366807ae2555e4388df66cbce1f091/jupyterlab-3.1.4.tar.gz"
  sha256 "82b5ea0f4bd500ff2a6aa27304a206007d7bbe8bc2bc5c685014d72462c985da"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f199307de48ee0343489c8f06272efd4700b60818efb18a87926b32936425e01"
    sha256 cellar: :any, big_sur:       "5b6be615e5699cf641311a25cfa7b6402b2e7d6bb9035bc2ef62b887cfa13464"
    sha256 cellar: :any, catalina:      "b882af3bd610be58d54ac127b2b1d4771de3d6eac838035b7b6477da0846ffce"
    sha256 cellar: :any, mojave:        "f9b0a576b977013cbc5ad9fd543497d8b78bf6e7feabd3c81becc850cb526329"
  end

  depends_on "ipython"
  depends_on "node"
  depends_on "pandoc"
  depends_on "python@3.9"
  depends_on "zeromq"

  uses_from_macos "expect" => :test

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/58/92/29df8cc2d38a54c1db0074bc745109b30edbcccf3ebac7c3c82c63cd692c/anyio-3.3.0.tar.gz"
    sha256 "ae57a67583e5ff8b4af47666ff5651c3732d45fd26c929253748e796af860374"
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
    url "https://files.pythonhosted.org/packages/ed/0c/0acbc89b1c229f5bb1b89b63af4ad60a49603a7933e2939f4e6cdbe00e14/bleach-4.0.0.tar.gz"
    sha256 "ffa9221c6ac29399cc50fcc33473366edd0cf8d5e2cbbbb63296dc327fb67cc8"
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
    url "https://files.pythonhosted.org/packages/e7/4e/2af0238001648ded297fb54ceb425ca26faa15b341b4fac5371d3938666e/charset-normalizer-2.0.4.tar.gz"
    sha256 "f23667ebe1084be45f6ae0538e4a5a865206544097e4e8bbcacf42cd02a348f3"
  end

  resource "debugpy" do
    url "https://files.pythonhosted.org/packages/33/75/ef3f07dab89949e1c252c49e33a3ae94dab17f95be9e4b6d86bec57fee0f/debugpy-1.4.1.zip"
    sha256 "889316de0b8ff3732927cb058cfbd3371e4cd0002ecc170d34c755ad289c867c"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/4f/51/15a4f6b8154d292e130e5e566c730d8ec6c9802563d58760666f1818ba58/decorator-5.0.9.tar.gz"
    sha256 "72ecfba4320a893c53f9706bebb2d55c270c1e51a28789361aa93e4a21319ed5"
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
    url "https://files.pythonhosted.org/packages/fa/95/b97ef5aef28de3d1cefc9b07304e85a35bce64da18be365df95db6ef2756/ipykernel-6.0.3.tar.gz"
    sha256 "0df34a78c7e1422800d6078cde65ccdcdb859597046c338c759db4dbc535c58f"
  end

  resource "ipython" do
    url "https://files.pythonhosted.org/packages/f8/3a/ed8de8c506df3e580ac08e154239c20fa651c5d73df173dfe30fa30fd4dc/ipython-7.26.0.tar.gz"
    sha256 "0cff04bb042800129348701f7bd68a430a844e8fb193979c08f6c99f28bb735e"
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
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/11/ef/d93cd8446f240fe9f332963eaf0766ea366d5536f8d7b50cd54bc4f39402/jupyter_client-6.2.0.tar.gz"
    sha256 "e2ab61d79fbf8b56734a4c2499f19830fbd7f6fefb3e87868ef0545cb3c17eb9"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/24/9a/0ca76ccc95eeb3ee376c671e81bda2c61d148c7627443004d1ba0d085b80/jupyter_core-4.7.1.tar.gz"
    sha256 "79025cb3225efcd36847d0840f3fc672c0abd7afd0de83ba8a1d3837619122b4"
  end

  resource "jupyter-server" do
    url "https://files.pythonhosted.org/packages/93/13/fbcf7e678b9eeedda0899a9b77bb93ad49b96cf05065cf3a1f3b312927ab/jupyter_server-1.10.2.tar.gz"
    sha256 "d3a3b68ebc6d7bfee1097f1712cf7709ee39c92379da2cc08724515bb85e72bf"
  end

  resource "jupyterlab-pygments" do
    url "https://files.pythonhosted.org/packages/d1/79/3677d138eeacbba7cf6d0e51e6b8c094448329f7b8a523a5d2599bc898e7/jupyterlab_pygments-0.1.2.tar.gz"
    sha256 "cfcda0873626150932f438eccf0f8bf22bfa92345b814890ab360d666b254146"
  end

  resource "jupyterlab-server" do
    url "https://files.pythonhosted.org/packages/0b/2e/c7935cf8bf13a5766e96277f7ccf051d1f1bf6d7aef7be87e2ed70c71a20/jupyterlab_server-2.6.2.tar.gz"
    sha256 "6dc6e7d26600d110b862acbfaa4d1a2c5e86781008d139213896d96178c3accd"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "matplotlib-inline" do
    url "https://files.pythonhosted.org/packages/c1/fb/3361c4bf5ae8ffb9249132e70f4853ef511c0894a938fdff29320df55534/matplotlib-inline-0.1.2.tar.gz"
    sha256 "f41d5ff73c9f5385775d5c0bc13b424535c8402fe70ea8210f93e11f3683993e"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/2d/a4/509f6e7783ddd35482feda27bc7f72e65b5e7dc910eca4ab2164daf9c577/mistune-0.8.4.tar.gz"
    sha256 "59a3429db53c50b5c6bcc8a07f8848cb00d7dc8bdb431a4ab41920d201d4756e"
  end

  resource "nbclassic" do
    url "https://files.pythonhosted.org/packages/04/1f/0bee7bae33531275a2fc193bfe24cc4602c97d9b8e49007bcf6c057a4c0f/nbclassic-0.3.1.tar.gz"
    sha256 "f920f8d09849bea7950e1017ff3bd101763a8d68f565a51ce053572e65aa7947"
  end

  resource "nbclient" do
    url "https://files.pythonhosted.org/packages/11/95/894f0f5e1671ffce42d22400717058c0a5e37d288a55427ef6ec605f1db6/nbclient-0.5.3.tar.gz"
    sha256 "db17271330c68c8c88d46d72349e24c147bb6f34ec82d8481a8f025c4d26589c"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/ad/4f/8c5575d08ef16d8fc02caf2ef940ef6ca5f5eedf48a14bcb97f507d52b87/nbconvert-6.1.0.tar.gz"
    sha256 "d22a8ff202644d31db254d24d52c3a96c82156623fcd7c7f987bba2612303ec9"
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
    url "https://files.pythonhosted.org/packages/bb/7b/de620d82888929137f565334246d6553e2d1b7880a0fc5bb6b511a143610/notebook-6.4.1.tar.gz"
    sha256 "2a67037730e2b2991f5d684ecb07255bbb191f49234888e71e1fabf8e50679a6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "pandocfilters" do
    url "https://files.pythonhosted.org/packages/28/78/bd59a9adb72fa139b1c9c186e6f65aebee52375a747e4b6a6dcf0880956f/pandocfilters-1.4.3.tar.gz"
    sha256 "bc63fbb50534b4b1f8ebe1860889289e8af94a23bff7445259592df25a3906eb"
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
    url "https://files.pythonhosted.org/packages/88/4b/2c0f9e2b52297bdeede91c8917c51575b125006da5d0485521fa2b1e0b75/prompt_toolkit-3.0.19.tar.gz"
    sha256 "08360ee3a3148bdb5163621709ee322ec34fc4375099afa4bbf751e9b7b7fa4f"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
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
    url "https://files.pythonhosted.org/packages/d6/67/98d0d6ac5c784190a0f9728410902471552cffc78cef37830cd86b9cd70d/pyzmq-22.2.1.tar.gz"
    sha256 "6d18c76676771fd891ca8e0e68da0bbfb88e30129835c0ade748016adb3b6242"
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
    url "https://files.pythonhosted.org/packages/6c/9d/d66cc2adbe7643b3ce8bc100a0e5283ca97aba40630763fabe76d4f7bbfc/Send2Trash-1.7.1.tar.gz"
    sha256 "17730aa0a33ab82ed6ca76be3bb25f0433d0014f1ccf63c979bab13a5b9db2b2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "terminado" do
    url "https://files.pythonhosted.org/packages/e1/83/0ea6eee5c5fd82278ebce1567e2d6703a97ff19fd4e07b9361894a64dfbb/terminado-0.10.1.tar.gz"
    sha256 "89d5dac2f4e2b39758a0ff9a3b643707c95a020a6df36e70583b88297cd59cbe"
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
    url "https://files.pythonhosted.org/packages/b8/24/e6dfe45ecfc4c2b0d6774565e631dc1b9e50de2c3536625d377963d56cae/traitlets-5.0.5.tar.gz"
    sha256 "178f4ce988f69189f7e523337a3e11d91c786ded9360174a3d9ca83e79bc5396"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
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
    url "https://files.pythonhosted.org/packages/bc/a6/5ef697df40e56459de75b57f302f2da92a51269925282a08e4eb76b16fb6/websocket-client-1.1.1.tar.gz"
    sha256 "4cf754af7e3b3ba76589d49f9e09fd9a6c0aae9b799a89124d656009c01a261d"
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
      shell_output("source #{bash_completion}/jupyter && complete -p jupyter")

    # Ensure that jupyter can load the jupyter lab package.
    assert_match(/^jupyter lab *: #{version}$/,
      shell_output(bin/"jupyter --version"))

    # Ensure that jupyter-lab binary was installed by pip.
    assert_equal version.to_s,
      shell_output(bin/"jupyter-lab --version").strip

    port = free_port
    fork { exec "#{bin}/jupyter-lab", "-y", "--port=#{port}", "--no-browser", "--LabApp.token=''" }
    sleep 10
    assert_match "<title>JupyterLab</title>",
      shell_output("curl --silent --fail http://localhost:#{port}/lab")
  end
end
