class LmEval < Formula
  include Language::Python::Virtualenv

  desc "Framework for few-shot evaluation of language models"
  homepage "https://github.com/EleutherAI/lm-evaluation-harness"
  url "https://files.pythonhosted.org/packages/e1/5e/e6d70f4aa2acd7932a873c51de93ddf2dbd1c43aa6f6c86314ab3c0d279d/lm_eval-0.4.9.2.tar.gz"
  sha256 "131c2f21911beee92e6ab8286f08adce86d6aa23852f87451651e6a68b4a631a"
  license "MIT"

  depends_on "cmake" => :build # for pyarrow
  depends_on "maturin" => :build
  depends_on "ninja" => :build # for pyarrow
  depends_on "rust" => :build # for hf-xet, safetensors, tokenizers
  depends_on "apache-arrow"
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "pytorch"
  depends_on "scipy"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  pypi_packages exclude_packages: %w[certifi numpy scipy torch]

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/10/2a/c93173ffa1b39c1d0395b7e842bbdc62e556ca9d8d3b5572926f3e4ca752/absl_py-2.3.1.tar.gz"
    sha256 "a97820526f7fbfd2ec1bce83f3f25e3a14840dac0d8e02a0b71cd75db3f77fc9"
  end

  resource "accelerate" do
    url "https://files.pythonhosted.org/packages/4a/8e/ac2a9566747a93f8be36ee08532eb0160558b07630a081a6056a9f89bf1d/accelerate-1.12.0.tar.gz"
    sha256 "70988c352feb481887077d2ab845125024b2a137a5090d6d7a32b57d03a45df6"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/1c/ce/3b83ebba6b3207a7135e5fcaba49706f8a4b6008153b4e30540c982fae26/aiohttp-3.13.2.tar.gz"
    sha256 "40176a52c186aefef6eb3cad2cdd30cd06e3afbe88fe8ab2af9c0b90f228daca"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/16/ce/8a777047513153587e5434fd752e89334ac33e379aa3497db860eeb60377/anyio-4.12.0.tar.gz"
    sha256 "73c693b567b0c55130c104d0b43a9baf3aa6a31fc6110116509f27bf75e21ec0"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "dataproperty" do
    url "https://files.pythonhosted.org/packages/0b/81/8c8b64ae873cb9014815214c07b63b12e3b18835780fb342223cfe3fe7d8/dataproperty-1.1.0.tar.gz"
    sha256 "b038437a4097d1a1c497695c3586ea34bea67fdd35372b9a50f30bf044d77d04"
  end

  resource "datasets" do
    url "https://files.pythonhosted.org/packages/c4/54/9359803da96bc65439a28fbb014dc2c90b7d4d8034a93b72362b0d40191f/datasets-4.4.2.tar.gz"
    sha256 "9de16e415c4ba4713eac0493f7c7dc74f3aa21599297f00cc6ddab409cb7b24b"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/12/80/630b4b88364e9a8c8c5797f4602d0f76ef820909ee32f0bacb9f90654042/dill-0.4.0.tar.gz"
    sha256 "0633f1d2df477324f53a895b02c901fb961bdbf65a17122586ea7019292cbcf0"
  end

  resource "evaluate" do
    url "https://files.pythonhosted.org/packages/ad/d0/0c17a8e6e8dc7245f22dea860557c32bae50fc4d287ae030cb0e8ab8720f/evaluate-0.4.6.tar.gz"
    sha256 "e07036ca12b3c24331f83ab787f21cc2dbf3631813a1631e63e40897c69a3f21"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/5e/6e/0f11bacf08a67f7fb5ee09740f2ca54163863b07b70d579356e9222ce5d8/hf_xet-1.2.0.tar.gz"
    sha256 "a8c27070ca547293b6890c4bf389f713f80e8c478631432962bb7f4bc0bd7d7f"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/98/63/4910c5fa9128fdadf6a9c5ac138e8b1b6cee4ca44bf7915bbfbce4e355ee/huggingface_hub-0.36.0.tar.gz"
    sha256 "47b3f0e2539c39bf5cde015d63b72ec49baff67b6931c3d97f3f84532e2b8d25"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/41/f2/d34e8b3a08a9cc79a50b2208a93dce981fe615b64d5a4d4abee421d898df/joblib-1.5.3.tar.gz"
    sha256 "8561a3269e6801106863fd0d6d84bb737be9e7631e33aaed3fb9ce5953688da3"
  end

  resource "jsonlines" do
    url "https://files.pythonhosted.org/packages/35/87/bcda8e46c88d0e34cad2f09ee2d0c7f5957bccdb9791b0b934ec84d84be4/jsonlines-4.0.0.tar.gz"
    sha256 "0c6d2c09117550c089995247f605ae4cf77dd1533041d366351f6f298822ea74"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "mbstrdecoder" do
    url "https://files.pythonhosted.org/packages/31/ab/05ae008357c8bdb6245ebf8a101d99f26c096e0ea20800b318153da23796/mbstrdecoder-1.1.4.tar.gz"
    sha256 "8105ef9cf6b7d7d69fe7fd6b68a2d8f281ca9b365d7a9b670be376b2e6c81b21"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/80/1e/5492c365f222f907de1039b91f922b93fa4f764c713ee858d235495d8f50/multidict-6.7.0.tar.gz"
    sha256 "c6e99d9a65ca282e578dfea819cfa9c0a62b2499d8677392e09feaf305e9e6f5"
  end

  resource "multiprocess" do
    url "https://files.pythonhosted.org/packages/72/fd/2ae3826f5be24c6ed87266bc4e59c46ea5b059a103f3d7e7eb76a52aeecb/multiprocess-0.70.18.tar.gz"
    sha256 "f9597128e6b3e67b23956da07cf3d2e5cba79e2f4e0fba8d7903636663ec6d0d"
  end

  resource "nltk" do
    url "https://files.pythonhosted.org/packages/f9/76/3a5e4312c19a028770f86fd7c058cf9f4ec4321c6cf7526bab998a5b683c/nltk-3.9.2.tar.gz"
    sha256 "0f409e9b069ca4177c1903c3e843eef90c7e92992fa4931ae607da6de49e1419"
  end

  resource "numexpr" do
    url "https://files.pythonhosted.org/packages/cb/2f/fdba158c9dbe5caca9c3eca3eaffffb251f2fb8674bf8e2d0aed5f38d319/numexpr-2.14.1.tar.gz"
    sha256 "4be00b1086c7b7a5c32e31558122b7b80243fe098579b170967da83f3152b48b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/33/01/d40b85317f86cf08d853a4f495195c73815fdf205eef3993821720274518/pandas-2.3.3.tar.gz"
    sha256 "e05e1af93b977f7eafa636d043f9f94c7ee3ac81af99c13508215942e64c993b"
  end

  resource "pathvalidate" do
    url "https://files.pythonhosted.org/packages/fa/2a/52a8da6fe965dea6192eb716b357558e103aea0a1e9a8352ad575a8406ca/pathvalidate-3.3.1.tar.gz"
    sha256 "b18c07212bfead624345bb8e1d6141cdcf15a39736994ea0b94035ad2b1ba177"
  end

  resource "peft" do
    url "https://files.pythonhosted.org/packages/4b/0c/f2938db546ac7fc961ab5917cd50fcf5d0d70b406de93e3faccaa504e152/peft-0.18.0.tar.gz"
    sha256 "c81c80b2056ab40c23d58ef25f74daab417ac653970718589a11a8af28218588"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/5e/77/65b857a69ed876e1951e88aaba60f5ce6120c33703f7cb61a3c894b8c1b6/portalocker-3.2.0.tar.gz"
    sha256 "1f3002956a54a8c3730586c5c77bf18fae4149e07eaf1c29fc3faf4d5a3f89ac"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/be/7c/31d1c3ceb1260301f87565f50689dc6da3db427ece1e1e012af22abca54e/psutil-7.2.0.tar.gz"
    sha256 "2e4f8e1552f77d14dc96fb0f6240c5b34a37081c0889f0853b3b29a496e5ef64"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/30/53/04a7fdc63e6056116c9ddc8b43bc28c12cdd181b85cbeadb79278475f3ae/pyarrow-22.0.0.tar.gz"
    sha256 "3d600dc583260d845c7d8a6db540339dd883081925da2bd1c5cb808f720b3cd9"
  end

  resource "pybind11" do
    url "https://files.pythonhosted.org/packages/2f/7b/a6d8dcb83c457e24a9df1e4d8fd5fb8034d4bbc62f3c324681e8a9ba57c2/pybind11-3.0.1.tar.gz"
    sha256 "9c0f40056a016da59bab516efb523089139fcc6f2ba7e4930854c61efb932051"
  end

  resource "pytablewriter" do
    url "https://files.pythonhosted.org/packages/f6/a1/617730f290f04d347103ab40bf67d317df6691b14746f6e1ea039fb57062/pytablewriter-1.2.1.tar.gz"
    sha256 "7bd0f4f397e070e3b8a34edcf1b9257ccbb18305493d8350a5dbc9957fced959"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cc/a9/546676f25e573a4cf00fe8e119b78a37b6a8fe2dc95cda877b30889c9c45/regex-2025.11.3.tar.gz"
    sha256 "1fedc720f9bb2494ce31a58a1631f9c82df6a09b49c19517ea5cc280b4541e01"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rouge-score" do
    url "https://files.pythonhosted.org/packages/e2/c5/9136736c37022a6ad27fea38f3111eb8f02fe75d067f9a985cc358653102/rouge_score-0.1.2.tar.gz"
    sha256 "c7d4da2683e68c9abf0135ef915d63a46643666f848e558a1b9f7ead17ff0f04"
  end

  resource "sacrebleu" do
    url "https://files.pythonhosted.org/packages/01/14/8526cf8a5b912b618e7d6ed319a5b1876788bebba1f9a660e1291832c1cc/sacrebleu-2.5.1.tar.gz"
    sha256 "1a088cc1c74ffaff0759c3191a85db09eecfa7a52e09be244e319d8d64e2fb11"
  end

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/29/9c/6e74567782559a63bd040a236edca26fd71bc7ba88de2ef35d75df3bca5e/safetensors-0.7.0.tar.gz"
    sha256 "07663963b67e8bd9f0b8ad15bb9163606cd27cc5a1b96235a50d8369803b96b0"
  end

  resource "scikit-learn" do
    url "https://files.pythonhosted.org/packages/0e/d4/40988bf3b8e34feec1d0e6a051446b1f66225f8529b9309becaeef62b6c4/scikit_learn-1.8.0.tar.gz"
    sha256 "9bccbb3b40e3de10351f8f5068e105d0f4083b1a65fa07b6634fbc401a6287fd"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlitedict" do
    url "https://files.pythonhosted.org/packages/12/9a/7620d1e9dcb02839ed6d4b14064e609cdd7a8ae1e47289aa0456796dd9ca/sqlitedict-2.1.0.tar.gz"
    sha256 "03d9cfb96d602996f1d4c2db2856f1224b96a9c431bdd16e78032a72940f9e8c"
  end

  resource "tabledata" do
    url "https://files.pythonhosted.org/packages/b2/35/171c8977162f1163368406deddde4c59673b62bd0cb2f34948a02effb075/tabledata-1.3.4.tar.gz"
    sha256 "e9649cab129d718f3bff4150083b77f8a78c30f6634a30caf692b10fdc60cb97"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tcolorpy" do
    url "https://files.pythonhosted.org/packages/80/cc/44f2d81d8f9093aad81c3467a5bf5718d2b5f786e887b6e4adcfc17ec6b9/tcolorpy-0.1.7.tar.gz"
    sha256 "0fbf6bf238890bbc2e32662aa25736769a29bf6d880328f310c910a327632614"
  end

  resource "threadpoolctl" do
    url "https://files.pythonhosted.org/packages/b7/4d/08c89e34946fce2aec4fbb45c9016efd5f4d7f24af8e5d93296e935631d8/threadpoolctl-3.6.0.tar.gz"
    sha256 "8ab8b4aa3491d812b623328249fab5302a68d2d71745c8a4c719a2fcaba9f44e"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/1c/46/fb6854cec3278fbfa4a75b50232c77622bc517ac886156e6afbfa4d8fc6e/tokenizers-0.22.1.tar.gz"
    sha256 "61de6522785310a309b3407bac22d99c4db5dba349935e99e4d15ea2226af2d9"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/dd/70/d42a739e8dfde3d92bb2fff5819cbf331fe9657323221e79415cd5eb65ee/transformers-4.57.3.tar.gz"
    sha256 "df4945029aaddd7c09eec5cad851f30662f8bd1746721b34cc031d70c65afebc"
  end

  resource "typepy" do
    url "https://files.pythonhosted.org/packages/79/59/4c39942077d7de285f762a91024dbda731be693591732977358f77d120fb/typepy-1.3.4.tar.gz"
    sha256 "89c1f66de6c6133209c43a94d23431d320ba03ef5db18f241091ea594035d9de"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5e/a7/c202b344c5ca7daf398f3b8a477eeb205cf3b6f32e7ec3a6bac0629ca975/tzdata-2025.3.tar.gz"
    sha256 "de39c2ca5dc7b0344f2eba86f49d614019d29f060fc4ebc8a417896a620b56a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1e/24/a2a2ed9addd907787d7aa0355ba36a6cadf1768b934c652ea78acbd59dcd/urllib3-2.6.2.tar.gz"
    sha256 "016f9c98bb7e98085cb2b4b17b87d2c702975664e4f060c6532e64d1c1a5e797"
  end

  resource "word2number" do
    url "https://files.pythonhosted.org/packages/4a/29/a31940c848521f0725f0df6b25dca8917f13a2025b0e8fcbe5d0457e45e6/word2number-1.1.zip"
    sha256 "70e27a5d387f67b04c71fbb7621c05930b19bfd26efd6851e6e0f9969dcde7d0"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/02/84/30869e01909fb37a6cc7e18688ee8bf1e42d57e7e0777636bd47524c43c7/xxhash-3.6.0.tar.gz"
    sha256 "f0162a78b13a0d7617b2845b90c763339d1f1d82bb04a4b07f4ab535cc5e05d6"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/57/63/0c6ebca57330cd313f6102b16dd57ffaf3ec4c83403dcb45dbd15c6f3ea1/yarl-1.22.0.tar.gz"
    sha256 "bebf8557577d4401ba8bd9ff33906f1376c877aa78d1fe216ad01b4d6745af71"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")

    # Install numpy and scipy from Homebrew formulas first
    # This prevents resources like safetensors from building them from source
    site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    numpy_site_packages = Formula["numpy"].opt_libexec/site_packages
    scipy_site_packages = Formula["scipy"].opt_libexec/site_packages

    # Create .pth files to link Homebrew numpy and scipy into the virtualenv
    (venv.site_packages/"homebrew-numpy.pth").write "import site; site.addsitedir('#{numpy_site_packages}')\n"
    (venv.site_packages/"homebrew-scipy.pth").write "import site; site.addsitedir('#{scipy_site_packages}')\n"

    # Install resources, excluding hf-xet which needs special handling
    venv.pip_install resources.reject { |r| r.name == "hf-xet" }

    # Install hf-xet separately - it needs special handling for ARM64
    resource("hf-xet").stage do
      if ENV.effective_arch == :armv8
        # Disable sha2-asm which requires a minimum of -march=armv8-a+crypto
        # The assembler on ARM64 build environments may not support these instructions
        # Search for all Cargo.toml files and update any that contain the sha2 dependency
        Dir.glob("**/Cargo.toml").each do |cargo_toml|
          next unless File.read(cargo_toml).include?('sha2 = { workspace = true, features = ["asm"] }')

          inreplace cargo_toml,
                    'sha2 = { workspace = true, features = ["asm"] }',
                    "sha2 = { workspace = true }"
        end
      end
      venv.pip_install Pathname.pwd
    end

    # Install the main package
    venv.pip_install_and_link buildpath

    # We depend on pytorch, but that's a separate formula, so install a `.pth` file to link them.
    # NOTE: This is an exception to our usual policy as building `pytorch` is complicated
    pth_contents = "import site; site.addsitedir('#{Formula["pytorch"].opt_libexec/site_packages}')\n"
    (venv.site_packages/"homebrew-pytorch.pth").write pth_contents
  end

  test do
    assert_match "acc_norm", shell_output(
      "#{bin}/lm-eval --model hf --model_args " \
      "pretrained=EleutherAI/pythia-14m,dtype=float32,device=cpu --tasks arc_easy --limit 1 --batch_size 1",
    )
  end
end
