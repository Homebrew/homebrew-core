class KeeperCommander < Formula
  include Language::Python::Virtualenv

  desc "Command-line and SDK interface to Keeper Password Manager"
  homepage "https://docs.keeper.io/en/privileged-access-manager/commander-cli/overview"
  url "https://files.pythonhosted.org/packages/5d/30/31eeed2f626139aa432f6cc6c92702c582cb23f5038f135158ae8ba07d59/keepercommander-17.2.4.tar.gz"
  sha256 "0dd79da6f59fe23c27b96b9815ad4b4493c3e1ea539d1f04372169a480cd0f8f"
  license "MIT"
  head "https://github.com/Keeper-Security/Commander.git", branch: "master"

  no_autobump! because: "macOS resources cannot be updated on linux CI"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c3a86289a705e042caa213c17bae06d64b533671439c4e032ef171069b4641b"
    sha256 cellar: :any,                 arm64_sequoia: "d45daf8bfb86bc7e5544e5ae0507c24509147bd79af217c39e02ef1a6a9f021d"
    sha256 cellar: :any,                 arm64_sonoma:  "f4c92198fed95e238d7f296f9e92c6ae1e1b9835c99f7f5f28c6b2aee6123564"
    sha256 cellar: :any,                 sonoma:        "7501f89f8dcaccb1ba74f2c2936c732ec85dec3526ec01a77ce0c5054d9e751f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ea33140191390d2a1d274d1fbaa6eb00facf676bf9afe47d66c2a01b09daee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fcd9300443d135e284d5827b27519af9b7e8e3407e17636a5cb0fda48116d98"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for bcrypt, keeper-pam-webrtc-rs

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "ffmpeg"
  depends_on "libvpx"
  depends_on "libyaml"
  depends_on "opus"
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "srtp"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
    depends_on "openssl@3"
  end

  on_intel do
    depends_on "libxcb"
    depends_on "openjpeg"
  end

  pypi_packages exclude_packages: %w[certifi cryptography pillow pydantic],
                extra_packages:   %w[cbor2 pyobjc-framework-localauthentication]

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
    url "https://files.pythonhosted.org/packages/d9/8e/8b4fdde28e42ffcd741a37f4ffa9fb59cd4fe01625b544dfcfd9ccb54f01/cbor2-5.8.0.tar.gz"
    sha256 "b19c35fcae9688ac01ef75bad5db27300c2537eb4ee00ed07e05d8456a0d4931"
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

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/49/85/12f0a49a7c4ffb70572b6c2ef13c90c88fd190debda93b23f026b25f9634/deprecated-1.3.1.tar.gz"
    sha256 "b1b50e0ff0c1fddaa5708a2c6b0a6588bb09b892825ab2b214ac9ea9d92a5223"
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
    url "https://files.pythonhosted.org/packages/4e/98/71780be5d1afb941219c4b48d241d4e246e3062b017caa4e79c4dc71314c/flask_limiter-4.1.1.tar.gz"
    sha256 "ca11608fc7eec43dcea606964ca07c3bd4ec1ae89043a0f67f717899a4f48106"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/ec/ca/cf17b88a8df95691275a3d77dc0a5ad9907f328ae53acbe6795da1b2f5ed/fonttools-4.61.1.tar.gz"
    sha256 "6675329885c44657f826ef01d9e4fb33b9158e9d93c537d84ad8399539bc6f69"
  end

  resource "fpdf2" do
    url "https://files.pythonhosted.org/packages/e9/c0/784b130a28f4ed612e9aff26d1118e1f91005713dcd0a35e60b54d316b56/fpdf2-2.8.5.tar.gz"
    sha256 "af4491ef2e0a5fe476f9d61362925658949c995f7e804438c0e81008f1550247"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/f3/49/3b30cad09e7771a4982d9975a8cbf64f00d4a1ececb53297f1d9a7be1b10/importlib_metadata-8.7.1.tar.gz"
    sha256 "49fef1ae6440c182052f407c8d34a68f72efc36db9ca90dc0113398f2fdde8bb"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "keeper-mlkem" do
    url "https://files.pythonhosted.org/packages/60/6e/18aff45dca0f76cd767ec75879235ea7f465d480adde5cce591b4ff24eda/keeper_mlkem-1.0.2.tar.gz"
    sha256 "52f472df2c7ebcad64770cdfbc1321bb4014009ec32f731a3faa2afd4870d837"
  end

  resource "keeper-pam-webrtc-rs" do
    url "https://files.pythonhosted.org/packages/41/54/89e01bb5e5235c091a39b84f16f690bf2a9a01c9e8616b35a1ae98f5b682/keeper_pam_webrtc_rs-1.2.5.tar.gz"
    sha256 "6e07dd2982aedaca5df67bfe33e14b51435cb92dcd139c2cc47663c822c9f342"

    # Remove `readme` field to avoid build error for missing file
    patch :DATA
  end

  resource "keeper-secrets-manager-core" do
    url "https://files.pythonhosted.org/packages/3b/4c/21b0b9569f96fc450a894b31ea066f4073944781a031b2f1940901257d53/keeper_secrets_manager_core-17.0.0.tar.gz"
    sha256 "f821d114b44ecd992870f4661d1daa5c50901d4abcc6d52c37926c372396d31c"
  end

  resource "limits" do
    url "https://files.pythonhosted.org/packages/bb/e5/c968d43a65128cd54fb685f257aafb90cd5e4e1c67d084a58f0e4cbed557/limits-5.6.0.tar.gz"
    sha256 "807fac75755e73912e894fdd61e2838de574c5721876a19f7ab454ae1fffb4b5"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
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
    url "https://files.pythonhosted.org/packages/34/44/e49ecff446afeec9d1a66d6bbf9adc21e3c7cea7803a920ca3773379d4f6/protobuf-6.33.2.tar.gz"
    sha256 "56dc370c91fbb8ac85bc13582c9e373569668a290aa2e66a590c2a0d35ddb9e4"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/73/cb/09e5184fb5fc0358d110fc3ca7f6b1d033800734d34cac10f4136cfac10e/psutil-7.2.1.tar.gz"
    sha256 "f7583aec590485b43ca601dd9cea0dcd65bd7bb21d30ef4ddbf4ea6b5ed1bdd3"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pyngrok" do
    url "https://files.pythonhosted.org/packages/f6/7c/788a44567ffbad7c2d838e79a388ae5045520410f953c5097ad664d4763d/pyngrok-7.5.0.tar.gz"
    sha256 "2fe91cba2c2531ecfb124b5071f377808b61a68a14ca3c99fcb7f3fdae05278f"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/b8/b6/d5612eb40be4fd5ef88c259339e6313f46ba67577a95d86c3470b951fce0/pyobjc_core-12.1.tar.gz"
    sha256 "2bb3903f5387f72422145e1466b3ac3f7f0ef2e9960afa9bcd8961c5cbf8bd21"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/02/a3/16ca9a15e77c061a9250afbae2eae26f2e1579eb8ca9462ae2d2c71e1169/pyobjc_framework_cocoa-12.1.tar.gz"
    sha256 "5556c87db95711b985d5efdaaf01c917ddd41d148b1e52a0c66b1a2e2c5c1640"
  end

  resource "pyobjc-framework-localauthentication" do
    url "https://files.pythonhosted.org/packages/8d/0e/7e5d9a58bb3d5b79a75d925557ef68084171526191b1c0929a887a553d4f/pyobjc_framework_localauthentication-12.1.tar.gz"
    sha256 "2284f587d8e1206166e4495b33f420c1de486c36c28c4921d09eec858a699d05"
  end

  resource "pyobjc-framework-security" do
    url "https://files.pythonhosted.org/packages/80/aa/796e09a3e3d5cee32ebeebb7dcf421b48ea86e28c387924608a05e3f668b/pyobjc_framework_security-12.1.tar.gz"
    sha256 "7fecb982bd2f7c4354513faf90ba4c53c190b7e88167984c2d0da99741de6da9"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1e/24/a2a2ed9addd907787d7aa0355ba36a6cadf1768b934c652ea78acbd59dcd/urllib3-2.6.2.tar.gz"
    sha256 "016f9c98bb7e98085cb2b4b17b87d2c702975664e4f060c6532e64d1c1a5e797"
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
    url "https://files.pythonhosted.org/packages/45/ea/b0f8eeb287f8df9066e56e831c7824ac6bab645dd6c7a8f4b2d767944f9b/werkzeug-3.1.4.tar.gz"
    sha256 "cd3cd98b1b92dc3b7b3995038826c68097dcb16f9baa63abe35f20eafeb9fe5e"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/49/2a/6de8a50cb435b7f42c46126cf1a54b2aab81784e74c8595c8e025e8f36d3/wrapt-2.0.1.tar.gz"
    sha256 "9c9c635e78497cacb81e84f8b11b23e0aacac7a136e73b8e5b2109a1d9fc468f"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  def install
    without = %w[keeper-pam-webrtc-rs]

    if OS.mac?
      # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"
      # pyobjc-core uses "-fdisable-block-signature-string" introduced in clang 17
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1699
    else
      # `pyobjc-*` dependencies are only needed on macOS
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

__END__
diff --git a/Cargo.toml b/Cargo.toml
index 6bdce2f..3106404 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -4,7 +4,6 @@ version = "1.2.4"
 edition = "2021"
 description = "Keeper PAM WebRTC for Python - A secure, stable, and high-performance Tube API for Python, providing WebRTC-based secure tunneling with enterprise-grade security and reliability optimizations."
 license = "MIT"
-readme = "README.md"
 
 [lib]
 name = "keeper_pam_webrtc_rs"
