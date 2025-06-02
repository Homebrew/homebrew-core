class CoboCli < Formula
  include Language::Python::Virtualenv

  desc "Cobo Command-line Tool"
  homepage "https://github.com/CoboGlobal/cobo-cli"
  url "https://files.pythonhosted.org/packages/3a/07/a80c6fb19a005c81b20b344b6d3f4b3631563d732d6aa91acdc569503e49/cobo_cli-0.0.5.tar.gz"
  sha256 "ae08b589fbf097c4cdac82e3802be2bf2faa98d7c710102c68c27cf6518dd98c"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "d5a8f6f864bce60e582cb73e9415a23ddbca53b543f29ea33eb67564110bf6cf"
    sha256 cellar: :any,                 arm64_sonoma:  "652be51343a462a3678ce3c57678694395c37c509a27a35bf1f32609850e8384"
    sha256 cellar: :any,                 arm64_ventura: "d80cd0db285dc6e99f55079ad565efca256acf5254e893fea2daa8d6cfe83c2b"
    sha256 cellar: :any,                 sonoma:        "40d4ab83dfbd6ed44d1906c52c45e2b4dab041f6ad20a3eb5fd923a71fb51908"
    sha256 cellar: :any,                 ventura:       "3dd94d11b64260f1077fa488eb910fca49277a5e9fafb9b20d8f9a8e036a6bc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fdfa10d3b87c9f44eebd3c6a3f67b3397849a2a0c49edd255b8f9132dfef43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1642e5cb6304cbf47ef746d55d38789f67264103b6b0913e2ccf2027a25e6632"
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
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
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
    url "https://files.pythonhosted.org/packages/bd/5c/cbfa41491d6c83b36471f2a2f75602349d20a8f88afd94f83c1e68bbc298/marshmallow-3.25.0.tar.gz"
    sha256 "5ba94a4eb68894ad6761a505eb225daf7e5cb7b4c32af62d4a45e9d42665bc31"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/6a/c7/ca334c2ef6f2e046b1144fe4bb2a5da8a4c574e7f2ebf7e16b34a6a2fa92/pydantic-2.10.5.tar.gz"
    sha256 "278b38dbbaec562011d659ee05f63346951b3a248a6f3642e1bc68894ea2b4ff"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/fc/01/f3e5ac5e7c25833db5eb555f7b7ab24cd6f8c322d3a3ad2d67a952dc0abc/pydantic_core-2.27.2.tar.gz"
    sha256 "eb026e5a4c1fee05726072337ff51d1efb6f59090b7da90d30ea58625b1ffb39"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/73/7b/c58a586cd7d9ac66d2ee4ba60ca2d241fa837c02bca9bea80a9a8c3d22a9/pydantic_settings-2.7.1.tar.gz"
    sha256 "10c9caad35e64bfb3c2fbf70a078c0e25cc92499782e5200747f942a065dec93"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/bc/57/e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58/python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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
    url "https://files.pythonhosted.org/packages/d4/19/b65f1a088ee23e37cdea415b357843eca8b1422a7b11a9eee6e35d4ec273/tomli_w-1.1.0.tar.gz"
    sha256 "49e847a3a304d516a169a601184932ef0f6b61623fe680f836a2aa7128ed0d33"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "typing-inspect" do
    url "https://files.pythonhosted.org/packages/dc/74/1789779d91f1961fa9438e9a8710cdae6bd138c80d7303996933d117264a/typing_inspect-0.9.0.tar.gz"
    sha256 "b23fc42ff6f6ef6954e4852c1fb512cdd18dbea03134f91f856a95ccc9461f78"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
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

    generate_completions_from_executable(bin/"cobo", shells: [:fish, :zsh], shell_parameter_format: :click)
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
