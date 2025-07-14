class CoboCli < Formula
  include Language::Python::Virtualenv

  desc "Cobo Command-line Tool"
  homepage "https://github.com/CoboGlobal/cobo-cli"
  url "https://files.pythonhosted.org/packages/3a/07/a80c6fb19a005c81b20b344b6d3f4b3631563d732d6aa91acdc569503e49/cobo_cli-0.0.5.tar.gz"
  sha256 "ae08b589fbf097c4cdac82e3802be2bf2faa98d7c710102c68c27cf6518dd98c"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7d3d9738eea4c343dc9d72e56cdfad3728cd9fb9ed65049f8ff6d742b1b370b7"
    sha256 cellar: :any,                 arm64_sonoma:  "05703fa9d04ca938bc65178424b14cc61b9965381d7018747b530311bf905d19"
    sha256 cellar: :any,                 arm64_ventura: "351b4ab2961a9dff678cef69118703c1d8bc249044f5a46ff21d372e4a11b3f2"
    sha256 cellar: :any,                 sonoma:        "64e4ca4c8f4e87610f586bb515932c79fb445fe647fc35c4f4f1883b6089e385"
    sha256 cellar: :any,                 ventura:       "35dacbdf50618e2bb63ae9e934fc67869fbef45b82c80bffa21c86ca698f2588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c4302b4b048a93b2ce658fc5f1cec2ee623da4dbe3a01445525f229ecd4b407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de8e9fd6fa00e1ccdeb3b768dfc5e6f7e0288e0036e1cc56c28fec7297d2f18f"
  end

  depends_on "certifi"
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "rust"

  uses_from_macos "libffi"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "dataclasses-json" do
    url "https://files.pythonhosted.org/packages/64/a4/f71d9cf3a5ac257c993b5ca3f93df5f7fb395c725e7f1e6479d2514173c3/dataclasses_json-0.6.7.tar.gz"
    sha256 "b6b3e528266ea45b9535223bc53ca645f5208833c29229e847b3f26a1cc55fc0"

    # poetry 2.0 build patch, upstream pr ref, https://github.com/lidatong/dataclasses-json/pull/554
    patch :DATA
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/48/ce/13508a1ec3f8bb981ae4ca79ea40384becc868bfae97fd1c942bb3a001b1/email_validator-2.2.0.tar.gz"
    sha256 "cb690f344c617a714f22e66ae771445a1ceb46821152df8e165c5f9a364582b7"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c0/89/37df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14/gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/ab/5e/5e53d26b42ab75491cda89b871dab9e97c840bf12c63ec58a1919710cd06/marshmallow-3.26.1.tar.gz"
    sha256 "e6d8affb6cb61d39d26402096dc0aee12d5a26d490a121f118d2e81dc0719dc6"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/00/dd/4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8c/pydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/c2/ef/3d61472b7801c896f9efd9bb8750977d9577098b05224c5c41820690155e/pydantic_settings-2.10.0.tar.gz"
    sha256 "7a12e0767ba283954f3fd3fefdd0df3af21b28aa849c40c35811d52d682fa876"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/88/2c/7bb1416c5620485aa793f2de31d3df393d3686aa8a8506d11e10e13c5baf/python_dotenv-1.1.0.tar.gz"
    sha256 "41f90bc6f5f177fb41f53e87666db362025010eb28f60a01c9143bfa33a2b2d5"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/18/87/302344fed471e44a87289cf4967697d07e532f2421fdaf868a303cbae4ff/tomli-2.2.1.tar.gz"
    sha256 "cd45e1dc79c835ce60f7404ec8119f2eb06d38b1deba146f07ced3bbc44505ff"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d1/bc/51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5/typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "typing-inspect" do
    url "https://files.pythonhosted.org/packages/dc/74/1789779d91f1961fa9438e9a8710cdae6bd138c80d7303996933d117264a/typing_inspect-0.9.0.tar.gz"
    sha256 "b23fc42ff6f6ef6954e4852c1fb512cdd18dbea03134f91f856a95ccc9461f78"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  # add poetry 2.0 build patch, upstream pr ref, https://github.com/CoboGlobal/cobo-cli/pull/8
  patch do
    url "https://github.com/CoboGlobal/cobo-cli/commit/a1b5c015ddbf9f635cb0d9638e879a909f4dba12.patch?full_index=1"
    sha256 "d54e9fc183662e780b42ae4c84d31da04e10183599295ca36672e6048e2377e9"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cobo", shells: [:bash, :fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "Available webhook event types:", shell_output("#{bin}/cobo webhook events")

    assert_match version.to_s, shell_output("#{bin}/cobo version")
  end
end

__END__
diff --git a/pyproject.toml b/pyproject.toml
index 93c5f21..9521dfe 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -1,12 +1,24 @@
-[tool.poetry]
+[project]
 name = "dataclasses-json"
 version = "0.6.7"
 description = "Easily serialize dataclasses to and from JSON."
-authors = ["Charles Li <charles.dt.li@gmail.com>"]
-maintainers = ['Charles Li <charles.dt.li@gmail.com>', 'Georgiy Zubrienko <gzu@ecco.com>', 'Vitaliy Savitskiy <visa@ecco.com>', 'Matthias Als <mata@ecco.com>']
+authors = [
+    { "name" = "Charles Li", "email" = "charles.dt.li@gmail.com" },
+]
+maintainers = [
+    { "name" = "Charles Li", "email" = "charles.dt.li@gmail.com" },
+    { "name" = "Georgiy Zubrienko", "email" = "gzu@ecco.com" },
+    { "name" = "Vitaliy Savitskiy", "email" = "visa@ecco.com" },
+    { "name" = "Matthias Als", "email" = "mata@ecco.com>" },
+]
 license = 'MIT'
 readme = "README.md"
-repository = 'https://github.com/lidatong/dataclasses-json'
+
+[project.urls]
+Repository = 'https://github.com/lidatong/dataclasses-json'
+Changelog = "https://github.com/lidatong/dataclasses-json/releases"
+Documentation = "https://lidatong.github.io/dataclasses-json/"
+Issues = "https://github.com/lidatong/dataclasses-json/issues"

 [tool.poetry.dependencies]
 python = "^3.7"
@@ -32,8 +44,3 @@ build-backend = "poetry_dynamic_versioning.backend"

 [tool.poetry-dynamic-versioning]
 enable = false
-
-[tool.poetry.urls]
-changelog = "https://github.com/lidatong/dataclasses-json/releases"
-documentation = "https://lidatong.github.io/dataclasses-json/"
-issues = "https://github.com/lidatong/dataclasses-json/issues"
