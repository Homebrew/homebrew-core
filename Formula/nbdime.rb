class Nbdime < Formula
  include Language::Python::Virtualenv

  desc "Jupyter Notebook Diff and Merge tools"
  homepage "https://nbdime.readthedocs.io"
  url "https://files.pythonhosted.org/packages/e1/36/28232d030c1b4a25116799f1aa3cd26208964f302daa324c314fd576820a/nbdime-3.1.1.tar.gz"
  sha256 "67767320e971374f701a175aa59abd3a554723039d39fae908e72d16330d648b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "920a7500122905431670569c488a6323808adf3e40cf23e582b515641ee99b90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05f6456be213cab941f0fac4d89a4e95b1859ee04aa34b18756b27e25edb5f1e"
    sha256 cellar: :any_skip_relocation, monterey:       "6f8720a05435bf74be2020260a4ab453453d792e3b7c2fdefe4c2d27208418dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a6b80d6642a2a030e815bbb7daabda366e80ccf7104f0aadbeb28a026e31185"
    sha256 cellar: :any_skip_relocation, catalina:       "136bf2a3a733c31d62c88afdf5ad873747d686e7a9b2ee00bb8b29e9669b05f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "185a9336eda62bfd8747264b6c0bdec5c86d008e0e3601e40a842769fe887b5a"
  end

  depends_on "python@3.10"
  depends_on "six"

  on_macos do
    resource "appnope" do
      url "https://files.pythonhosted.org/packages/e9/bc/2d2c567fe5ac1924f35df879dbf529dd7e7cabd94745dc9d89024a934e76/appnope-0.1.2.tar.gz"
      sha256 "dd83cd4b5b460958838f6eb3000c660b1f9caf2a5b1de4264e941512f603258a"
    end
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/66/02/ca9061e93c487a897859e3a41f6c1a4f494038d2791382169b9a0c528175/anyio-3.3.4.tar.gz"
    sha256 "67da67b5b21f96b9d3d65daa6ea99f5d5282cb09f50eb4456f8fb51dffefc3ff"
  end

  resource "argon2-cffi" do
    url "https://files.pythonhosted.org/packages/7b/39/a26aaef5c3f0c6cfd67c80599b5b40a794fdab46f4ee3be925d71e2f9596/argon2-cffi-21.1.0.tar.gz"
    sha256 "f710b61103d1a1f692ca3ecbd1373e28aa5e545ac625ba067ff2feca1b2bb870"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/6a/a3/217842324374fd3fb33db0eb4c2909ccf3ecc5a94f458088ac68581f8314/bleach-4.1.0.tar.gz"
    sha256 "0900d8b37eba61a802ee40ac0061f8c2b5dee29c1927dd1d233e075ebf5a71da"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c/entrypoints-0.3.tar.gz"
    sha256 "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/34/cc/aaa7a0d066ac9e94fbffa5fcf0738f5742dd7095bdde950bd582fca01f5a/GitPython-3.1.24.tar.gz"
    sha256 "df83fdf5e684fef7c6ee2c02fc68a5ceb7e7e759d08b694088d0cacb4eba59e5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f8/86/7c0eb6e8b05385d1ce682abc0f994abd1668e148fb52603fa86e15d4c110/Jinja2-3.0.2.tar.gz"
    sha256 "827a0e32839ab1600d4eb1c4c33ec5a8edfbc5cb42dafa13b81f182f97784b45"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/94/b9/8be410108f775bbb97d74b9d95fbcaa8ca55de9f43fe73c5a3bd82a3a867/jsonschema-4.1.2.tar.gz"
    sha256 "5c1a282ee6b74235057421fd0f766ac5f2972f77440927f6471c9e8493632fac"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/be/4f/7d2e1764ba352cf764d5e08fa4a1576c3e11e5c233e832b7f03af2e39482/jupyter_client-7.0.6.tar.gz"
    sha256 "8b6e06000eb9399775e0a55c52df6c1be4766666209c22f90c2691ded0e338dc"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/bb/dc/bb0e8b5093582699271df99cad202390e5cfcdb6bc5e772ca2fa8f61ade6/jupyter_core-4.8.1.tar.gz"
    sha256 "ef210dcb4fca04de07f2ead4adf408776aca94d17151d6f750ad6ded0b91ea16"
  end

  resource "jupyter-server" do
    url "https://files.pythonhosted.org/packages/59/e6/883cfe63668d140f4246ba712b6d7e44d44d755b570ff1a4dec0267035d2/jupyter_server-1.11.1.tar.gz"
    sha256 "ab7ab1cc38512f15026cbcbb96300fb46ec8b24aa162263d9edd00e0a749b1e8"
  end

  resource "jupyter-server-mathjax" do
    url "https://files.pythonhosted.org/packages/f1/6f/aaa531dfcfd5b2179184beccf246401db7fe6d860a77993daf471fc14594/jupyter_server_mathjax-0.2.3.tar.gz"
    sha256 "564e8d1272019c6771208f577b5f9f2b3afb02b9e2bff3b34c042cef8ed84451"
  end

  resource "jupyterlab-pygments" do
    url "https://files.pythonhosted.org/packages/d1/79/3677d138eeacbba7cf6d0e51e6b8c094448329f7b8a523a5d2599bc898e7/jupyterlab_pygments-0.1.2.tar.gz"
    sha256 "cfcda0873626150932f438eccf0f8bf22bfa92345b814890ab360d666b254146"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/2d/a4/509f6e7783ddd35482feda27bc7f72e65b5e7dc910eca4ab2164daf9c577/mistune-0.8.4.tar.gz"
    sha256 "59a3429db53c50b5c6bcc8a07f8848cb00d7dc8bdb431a4ab41920d201d4756e"
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

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "pandocfilters" do
    url "https://files.pythonhosted.org/packages/62/42/c32476b110a2d25277be875b82b5669f2cdda7897c165bd22b78f366b3cb/pandocfilters-1.5.0.tar.gz"
    sha256 "0b679503337d233b4339a817bfc8c50064e2eff681314376a47cb582305a7a38"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/a1/90/7f1a14c2d0638e1a6981612171881733ef015cbabbded709ac3ab3d2920a/prometheus_client-0.11.0.tar.gz"
    sha256 "3a8baade6cb80bcfe43297e33e7623f3118d660d41387593758e2fb1ea173a86"
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
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/31/c9/b29ea153b9bffaae787ecc81873b4b51bd36cc13c37586b41891beae37eb/pyparsing-3.0.1.tar.gz"
    sha256 "84196357aa3566d64ad123d7a3c67b0e597a115c4934b097580e5ce220b91531"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/f4/d7/0fa558c4fb00f15aabc6d42d365fcca7a15fcc1091cd0f5784a14f390b7f/pyrsistent-0.18.0.tar.gz"
    sha256 "773c781216f8c2900b42a7b638d5b517bb134ae1acbebe4d1e8f1f41ea60eb4b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
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

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
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
    url "https://files.pythonhosted.org/packages/db/cf/e6cbf07ce2d21a17c8379f3f2f12db413a38da5ee20809638226b1490e48/traitlets-5.1.1.tar.gz"
    sha256 "059f456c5a7c1c82b98c2e8c799f39c9b8128f6d0d46941ee118daace9eb70c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
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
    virtualenv_install_with_resources
  end

  test do
    (testpath/"old.ipynb").write <<~EOS
      {
       "cells": [
        {
         "cell_type": "code",
         "execution_count": null,
         "metadata": {},
         "outputs": [],
         "source": [
          "print(\\\"Hello World!\\\")"
         ]
        }
       ],
       "metadata": {
        "kernelspec": {
         "display_name": "Python 2",
         "language": "python",
         "name": "python2"
        },
        "language_info": {
         "codemirror_mode": {
          "name": "ipython",
          "version": 2
         },
         "file_extension": ".py",
         "mimetype": "text/x-python",
         "name": "python",
         "nbconvert_exporter": "python",
         "pygments_lexer": "ipython2",
         "version": "2.7.10"
        }
       },
       "nbformat": 4,
       "nbformat_minor": 1
      }
    EOS
    (testpath/"new.ipynb").write <<~EOS
      {
       "cells": [
        {
         "cell_type": "code",
         "execution_count": 1,
         "metadata": {},
         "outputs": [
          {
           "name": "stdout",
           "output_type": "stream",
           "text": [
            "Hello World!\\n"
           ]
          }
         ],
         "source": [
          "print(\\\"Hello World!\\\")"
         ]
        }
       ],
       "metadata": {
        "kernelspec": {
         "display_name": "Python 2",
         "language": "python",
         "name": "python2"
        },
        "language_info": {
         "codemirror_mode": {
          "name": "ipython",
          "version": 2
         },
         "file_extension": ".py",
         "mimetype": "text/x-python",
         "name": "python",
         "nbconvert_exporter": "python",
         "pygments_lexer": "ipython2",
         "version": "2.7.10"
        }
       },
       "nbformat": 4,
       "nbformat_minor": 1
      }
    EOS
    # sadly no special exit code if files are the same
    diff_output = shell_output("#{bin}/nbdiff --no-color old.ipynb new.ipynb")
    assert_match "nbdiff old.ipynb new.ipynb", diff_output
    assert_match(/--- old.ipynb  \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}.\d{6}/, diff_output)
    assert_match(/\+\+\+ new.ipynb  \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}.\d{6}/, diff_output)
  end
end
