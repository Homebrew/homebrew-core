class KeeperCommander < Formula
  include Language::Python::Virtualenv

  desc "Command-line and SDK interface to Keeper Password Manager"
  homepage "https://docs.keeper.io/en/privileged-access-manager/commander-cli/overview"
  url "https://files.pythonhosted.org/packages/7f/f2/3907876d7fe2ccee8ff28eb04a74fc367756f6fdf5e08ab20d7416c951eb/keepercommander-17.1.10.tar.gz"
  sha256 "888974f5ef18e839c172209aed4f010f4cbbf7e4686fa51878983b563f44d1e2"
  license "MIT"
  head "https://github.com/Keeper-Security/Commander.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "92eb8728378ccc3bf14c6d06a34bda7be1e16267043a9f8d273bd5899e336646"
    sha256 cellar: :any,                 arm64_sequoia: "96387169e722df855440e04ef424cfc602d1cc28737dbcf7da5adfc32890d859"
    sha256 cellar: :any,                 arm64_sonoma:  "9736bae4130da14bd1855efc72c23db111c987589d4e66c7d002ed77a04f1785"
    sha256 cellar: :any,                 sonoma:        "06da4087c51329041ebee47f2481a547553caaf395bf211695607b14bac7ee0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0441592b69ffb5dc93b8680574062296e3bcbcb9d2c6c0affa235b64ada3dd2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a27df080a51810a51ab769d966f0df7626a21d4ad9c3a254a42fe3f001d94b23"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # bcrypt dependencies

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "ffmpeg"
  depends_on "libvpx"
  depends_on "libyaml"
  depends_on "opus"
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "srtp"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
    depends_on "openssl@3"
  end

  on_intel do
    depends_on "libxcb"
    depends_on "openjpeg"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "asciitree" do
    url "https://files.pythonhosted.org/packages/2d/6a/885bc91484e1aa8f618f6f0228d76d0e67000b0fdd6090673b777e311913/asciitree-0.3.3.tar.gz"
    sha256 "4aa4b9b649f85e3fcb343363d97564aa1fb62e249677f2e18a96765145cc0f6e"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/3a/89/01df16cdc9c60c07956756c90fe92c684021003079e358a78e213bce45a2/cbor2-5.7.0.tar.gz"
    sha256 "3f6d843f4db4d0ec501c46453c22a4fbebb1abfb5b740e1bcab34c615cd7406b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/8d/b9/6ec8d8ec5715efc6ae39e8694bd48d57c189906f0628558f56688d0447b2/fido2-2.0.0.tar.gz"
    sha256 "3061cd05e73b3a0ef6afc3b803d57c826aa2d6a9732d16abd7277361f58e7964"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/dc/6d/cfe3c0fcc5e477df242b98bfe186a4c34357b4847e87ecaef04507332dab/flask-3.1.2.tar.gz"
    sha256 "bf656c15c80190ed628ad08cdfd3aaa35beb087855e2f494910aa3774cc4fd87"
  end

  resource "flask-limiter" do
    url "https://files.pythonhosted.org/packages/e4/53/13ccac4772f7efd58e4b8308e2b8bfaef3a45a4420ec43966f2dbff904c8/flask_limiter-4.0.0.tar.gz"
    sha256 "536a8df0bb2033f415a2212e19a3b7ddfea38585ac5a2444e1cfa986a697847c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/4b/42/97a13e47a1e51a5a7142475bbcf5107fe3a68fc34aef331c897d5fb98ad0/fonttools-4.60.1.tar.gz"
    sha256 "ef00af0439ebfee806b25f24c8f92109157ff3fac5731dc7867957812e87b8d9"
  end

  resource "fpdf2" do
    url "https://files.pythonhosted.org/packages/87/ff/4a1dd414e5c5df5a11904118afdb544f3a446c9c512cc77e9741cf74fb30/fpdf2-2.8.4.tar.gz"
    sha256 "12b1f1dd35d0c2f35284bcfe10b153d6ca4baf29377379843e73d3f971eab6b7"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/76/66/650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0/importlib_metadata-8.7.0.tar.gz"
    sha256 "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "keeper-pam-webrtc-rs" do
    url "https://files.pythonhosted.org/packages/f5/6e/21fb44759eb8133ae47c734165860df37aa68ab133e9a0b7cad25192ba3e/keeper_pam_webrtc_rs-1.0.0.tar.gz"
    sha256 "b7b2f8ca4a93c80da421a09796ab32bc5fc52ebb5f7003a0257fe9d5426e2e0f"
  end

  resource "keeper-secrets-manager-core" do
    url "https://files.pythonhosted.org/packages/3b/4c/21b0b9569f96fc450a894b31ea066f4073944781a031b2f1940901257d53/keeper_secrets_manager_core-17.0.0.tar.gz"
    sha256 "f821d114b44ecd992870f4661d1daa5c50901d4abcc6d52c37926c372396d31c"
  end

  resource "limits" do
    url "https://files.pythonhosted.org/packages/bb/e5/c968d43a65128cd54fb685f257aafb90cd5e4e1c67d084a58f0e4cbed557/limits-5.6.0.tar.gz"
    sha256 "807fac75755e73912e894fdd61e2838de574c5721876a19f7ab454ae1fffb4b5"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/fa/a4/cc17347aa2897568beece2e674674359f911d6fe21b0b8d6268cd42727ac/protobuf-6.32.1.tar.gz"
    sha256 "ee2469e4a021474ab9baafea6cd070e5bf27c7d29433504ddea1a4ee5850f68d"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/ff/5d/09a551ba512d7ca404d785072700d3f6727a02f6f3c24ecfd081c7cf0aa8/pydantic-2.11.9.tar.gz"
    sha256 "6b8ffda597a14812a7975c90b82a8a2e777d9257aba3453f973acd3c032a18e2"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyngrok" do
    url "https://files.pythonhosted.org/packages/a3/40/f06cbabac68bf2ff33b499d32373dedc20ebec3da814c26f82281f3c9bec/pyngrok-7.4.0.tar.gz"
    sha256 "1f786fed8d156b99bffd713096a7ec8c81181f949c8f5c920f6820e92d6b9876"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/e8/e9/0b85c81e2b441267bca707b5d89f56c2f02578ef8f3eafddf0e0c0b8848c/pyobjc_core-11.1.tar.gz"
    sha256 "b63d4d90c5df7e762f34739b39cc55bc63dbcf9fb2fb3f2671e528488c7a87fe"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/4b/c5/7a866d24bc026f79239b74d05e2cf3088b03263da66d53d1b4cf5207f5ae/pyobjc_framework_cocoa-11.1.tar.gz"
    sha256 "87df76b9b73e7ca699a828ff112564b59251bb9bbe72e610e670a4dc9940d038"
  end

  resource "pyobjc-framework-localauthentication" do
    url "https://files.pythonhosted.org/packages/e5/27/9e3195f3561574140e9b9071a36f7e0ebd18f50ade9261d23b5b9df8fccd/pyobjc_framework_localauthentication-11.1.tar.gz"
    sha256 "3cd48907c794bd414ac68b8ac595d83c7e1453b63fc2cfc2d2035b690d31eaa1"
  end

  resource "pyobjc-framework-security" do
    url "https://files.pythonhosted.org/packages/ee/6f/ba50ed2d9c1192c67590a7cfefa44fc5f85c776d1e25beb224dec32081f6/pyobjc_framework_security-11.1.tar.gz"
    sha256 "dabcee6987c6bae575e2d1ef0fcbe437678c4f49f1c25a4b131a5e960f31a2da"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  def install
    without = ["keeper-pam-webrtc-rs"]
    if OS.mac?
      # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"
      # pyobjc-core uses "-fdisable-block-signature-string" introduced in clang 17
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1699
    else
      without += resources.filter_map { |r| r.name if r.name.start_with?("pyobjc") }
    end
    venv = virtualenv_install_with_resources(without:)

    # Workaround for `Caused by: Failed to read readme specified in pyproject.toml`
    resource("keeper-pam-webrtc-rs").stage do
      inreplace "pyproject.toml", "readme = \"README.md\"", ""
      venv.pip_install Pathname.pwd
    end
  end

  test do
    assert_match "keepersecurity.com", shell_output("#{bin}/keeper server")
  end
end
