class Nbdime < Formula
  include Language::Python::Virtualenv

  desc "Jupyter Notebook Diff and Merge tools"
  homepage "https://nbdime.readthedocs.io"
  url "https://files.pythonhosted.org/packages/e1/36/28232d030c1b4a25116799f1aa3cd26208964f302daa324c314fd576820a/nbdime-3.1.1.tar.gz"
  sha256 "67767320e971374f701a175aa59abd3a554723039d39fae908e72d16330d648b"
  license "BSD-3-Clause"
  revision 1

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

  resource "appnope" do
    on_macos do
      url "https://files.pythonhosted.org/packages/e9/bc/2d2c567fe5ac1924f35df879dbf529dd7e7cabd94745dc9d89024a934e76/appnope-0.1.2.tar.gz"
      sha256 "dd83cd4b5b460958838f6eb3000c660b1f9caf2a5b1de4264e941512f603258a"
    end
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/67/c4/fd50bbb2fb72532a4b778562e28ba581da15067cfb2537dbd3a2e64689c1/anyio-3.6.1.tar.gz"
    sha256 "413adf95f93886e442aea925f3ee43baa5a765a64a0f52c6081894f9992fdd0b"
  end

  resource "argon2-cffi" do
    url "https://files.pythonhosted.org/packages/3f/18/20bb5b6bf55e55d14558b57afc3d4476349ab90e0c43e60f27a7c2187289/argon2-cffi-21.3.0.tar.gz"
    sha256 "d384164d944190a7dd7ef22c6aa3ff197da12962bd04b17f64d4e93d934dba5b"
  end

  resource "argon2-cffi-bindings" do
    url "https://files.pythonhosted.org/packages/b9/e9/184b8ccce6683b0aa2fbb7ba5683ea4b9c5763f1356347f1312c32e3c66e/argon2-cffi-bindings-21.2.0.tar.gz"
    sha256 "bb89ceffa6c791807d1305ceb77dbfacc5aa499891d2c55661c6459651fc39e3"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/e8/b0/cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7/beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/c2/5d/d5d45a38163ede3342d6ac1ca01b5d387329daadf534a25718f9a9ba818c/bleach-5.0.1.tar.gz"
    sha256 "0d03255c47eb9bd2f26aa9bb7f2107732e7e8fe195ca2f64709fcf3b0a4a085c"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/ea/8d/a7121ffe5f402dc015277d2d31eb82d2187334503a011c18f2e78ecbb9b2/entrypoints-0.4.tar.gz"
    sha256 "b706eddaa9218a19ebcd67b56818f05bb27589b1ca9e8d797b74affad4ccacd4"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/2f/ca/b8cd48dde1f4f1811c7ffd49253af87c1cb6523d2aaa5402a83d9fecc197/fastjsonschema-2.16.1.tar.gz"
    sha256 "d6fa3ffbe719768d70e298b9fb847484e2bdfdb7241ed052b8d57a9294a8c334"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/d6/39/5b91b6c40570dc1c753359de7492404ba8fe7d71af40b618a780c7ad1fc7/GitPython-3.1.27.tar.gz"
    sha256 "1c885ce809e8ba2d88a29befeb385fcea06338d3640712b59ca623c220bb5704"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/35/ee/889aee424a43066a06ac68e499335877775eac9b4409f7860f6af94c6688/jsonschema-4.14.0.tar.gz"
    sha256 "15062f4cc6f591400cd528d2c355f2cfa6a57e44c820dc783aee5e23d36a831f"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/bf/88/38e5592f8443d992de9fcb32d345260f94181408b43fba381e0e37aa7121/jupyter_client-7.3.4.tar.gz"
    sha256 "aa9a6c32054b290374f95f73bb0cae91455c58dfb84f65c8591912b8f65e6d56"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/e4/e0/13fc7f8b72f39d87c1c32918a99475911b7b2f28c1a9f2734a5ab5cc35ef/jupyter_core-4.11.1.tar.gz"
    sha256 "2e5f244d44894c4154d06aeae3419dd7f1b0ef4494dc5584929b398c61cfd314"
  end

  resource "jupyter-server" do
    url "https://files.pythonhosted.org/packages/5b/6e/01af30a3e12d2f8eda1405ca8710442f1e7d05d30f8abbfca3b1f0375ce0/jupyter_server-1.18.1.tar.gz"
    sha256 "2b72fc595bccae292260aad8157a0ead8da2c703ec6ae1bb7b36dbad0e267ea7"
  end

  resource "jupyter-server-mathjax" do
    url "https://files.pythonhosted.org/packages/9c/40/9a1b8c2a2e44e8e2392174cd8e52e0c976335f004301f61b66addea3243e/jupyter_server_mathjax-0.2.6.tar.gz"
    sha256 "bb1e6b6dc0686c1fe386a22b5886163db548893a99c2810c36399e9c4ca23943"
  end

  resource "jupyterlab-pygments" do
    url "https://files.pythonhosted.org/packages/69/8e/8ae01f052013ee578b297499d16fcfafb892927d8e41c1a0054d2f99a569/jupyterlab_pygments-0.2.2.tar.gz"
    sha256 "7405d7fde60819d905a9fa8ce89e4cd830e318cdad22a0030f7a901da705585d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/cd/9b/0f98334812f548a5ee4399b76e33752a74fc7bb976f5efb34d962f03d585/mistune-2.0.4.tar.gz"
    sha256 "9ee0a66053e2267aba772c71e06891fa8f1af6d4b01d5e84e267b4570d4d9808"
  end

  resource "nbclient" do
    url "https://files.pythonhosted.org/packages/16/53/4f3ce1dc291ff818c10ff1fcec34a9a7eca404a174d6012dd660629d33e9/nbclient-0.6.7.tar.gz"
    sha256 "3c5a7fc6bb74be7d31edf2817b44501a65caa99e5e56363bc359649b97cd24b9"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/c2/81/8ed17db18332322982cec44123432b75c1f1b1e9205d8573cbd55dd74c90/nbconvert-7.0.0.tar.gz"
    sha256 "fd1e361da30e30e4c5a5ae89f7cae95ca2a4d4407389672473312249a7ba0060"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/2c/ed/ce3e63f5e757442cbb01ac45683fb0338d48f7e824606957d933bc831a58/nbformat-5.4.0.tar.gz"
    sha256 "44ba5ca6acb80c5d5a500f1e5b83ede8cbe364d5a495c4c8cf60aaf1ba656501"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/7b/19/efddf713ba62f738d2bf410a6f5ead6e621f9354d5824091ce8b7a233e11/nest_asyncio-1.5.5.tar.gz"
    sha256 "e442291cd942698be619823a17a86a5759eabe1f8613084790de189fe9e16d65"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pandocfilters" do
    url "https://files.pythonhosted.org/packages/62/42/c32476b110a2d25277be875b82b5669f2cdda7897c165bd22b78f366b3cb/pandocfilters-1.5.0.tar.gz"
    sha256 "0b679503337d233b4339a817bfc8c50064e2eff681314376a47cb582305a7a38"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/98/71/2f16cce64055263146eff950affe7b1ab2ff78736ff0d2b5578bc0817e49/prometheus_client-0.14.1.tar.gz"
    sha256 "5459c427624961076277fdc6dc50540e2bacb98eebde99886e59ec55ed92093a"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/42/ac/455fdc7294acc4d4154b904e80d964cc9aae75b087bbf486be04df9f2abd/pyrsistent-0.18.1.tar.gz"
    sha256 "d4d61f8b993a7255ba714df3aca52700f8125289f84f704cf80916517c46eb96"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/72/37/d5603f352522e249e44ee767a8a59b3fe7cf7f708a94fd40a637c6890add/pyzmq-23.2.1.tar.gz"
    sha256 "2b381aa867ece7d0a82f30a0c7f3d4387b7cf2e0697e33efaa5bed6c5784abcd"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "Send2Trash" do
    url "https://files.pythonhosted.org/packages/49/2c/d990b8d5a7378dde856f5a82e36ed9d6061b5f2d00f39dc4317acd9538b4/Send2Trash-1.8.0.tar.gz"
    sha256 "d2c24762fd3759860a0aff155e45871447ea58d2be6bdd39b5c8f966a0c99c2d"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  resource "terminado" do
    url "https://files.pythonhosted.org/packages/4b/27/79dabfeda57d2a878611b41f7d9a401b3b6509c610ec90121a980df0a600/terminado-0.15.0.tar.gz"
    sha256 "ab4eeedccfcc1e6134bfee86106af90852c69d602884ea3a1e8ca6d4486e9bfe"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/1e/5a/576828164b5486f319c4323915b915a8af3fa4a654bbb6f8fc8e87b5cb17/tinycss2-1.1.1.tar.gz"
    sha256 "b2e44dd8883c360c35dd0d1b5aad0b610e5156c2cb3b33434634e539ead9d8bf"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/f3/9e/225a41452f2d9418d89be5e32cf824c84fe1e639d350d6e8d49db5b7f73a/tornado-6.2.tar.gz"
    sha256 "9b630419bde84ec666bfd7ea0a4cb2a8a651c2d5cccdbdd1972a0c859dfc3c13"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/b2/ed/3c842dbe5a8f0f1ebf3f5b74fc1a46601ed2dfe0a2d256c8488d387b14dd/traitlets-5.3.0.tar.gz"
    sha256 "0bb9f1f9f017aa8ec187d8b1b2a7a6626a2a1d877116baba52a129bfa124f8e2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/0e/e7/e705ead133d21de4be752af4b3a0cb1f02514ff45bf165b3955c1ce22077/websocket-client-1.3.3.tar.gz"
    sha256 "d58c5f284d6a9bf8379dab423259fe8f85b70d5fa5d2916d5791a84594b122b1"
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
