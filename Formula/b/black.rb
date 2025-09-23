class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://black.readthedocs.io/en/stable/"
  license "MIT"
  revision 1
  head "https://github.com/psf/black.git", branch: "main"

  stable do
    url "https://files.pythonhosted.org/packages/94/49/26a7b0f3f35da4b5a65f081943b7bcd22d7002f5f0fb8098ec1ff21cb6ef/black-25.1.0.tar.gz"
    sha256 "33496d5cd1222ad73391352b4ae8da15253c5de89b93a80b3e2c8d9a19ec2666"

    # build patch for mypy 1.16
    patch do
      url "https://github.com/psf/black/commit/e7bf7b4619928da69d486f36fcb456fb201ff53e.patch?full_index=1"
      sha256 "7cf2ae3e16f59580d1d2804e6696070546888bf136c615ababeb661cdee274ed"
    end
    # Fix mypy type issue
    # https://github.com/psf/black/commit/57a461258f324e33bca189b2eb49d7f7a944ffe7
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c4ad364a6a98d8499106a758c664ffbaf1e818af2349256b5ee286854f9a33e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49b07cf531d62e77ff6f69f9da81a18766f2d8d5769fdaebb3d3cff6045f9607"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b60423982fc49c9d793571d1315671537ebc934a8b02c2bb57b06853a2ec257"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "871521b20363443bdd2397066751ef2c33fd7fc08a6a2d88056971b3499a852e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2da651914131fea67046b653880bea5fc05ded7776ee34d7a68085b41833a565"
    sha256 cellar: :any_skip_relocation, ventura:       "3af971c0d93c88d60066694aa2b0d8cf239fa5ce5612693e3e06833d17ce1970"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fbd30e2186c2594a87f244b82a4fb57e5d9de7979d7aaeaeaffcc5a59c85474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fd483bdc26c389f02ef3baf59b2cb596239bd5513f03c402994962e1a2fd9f2"
  end

  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/e6/0b/e39ad954107ebf213a2325038a3e7a506be3d98e1435e1f82086eec4cde2/aiohttp-3.12.14.tar.gz"
    sha256 "6e06e120e34d93100de448fd941522e11dafa78ef1a893c179901b7d66aa29f2"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/79/b1/b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6/frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/3d/2c/5dad12e82fbdf7470f29bff2171484bf07cb3b16ada60a6589af8f376440/multidict-6.6.3.tar.gz"
    sha256 "798a9eb12dab0a6c2e29c1de6f3468af5cb2da6053a20dfa3344907eed0937cc"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a6/16/43264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776/propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/3c/fb/efaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963/yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  def install
    ENV["HATCH_BUILD_HOOK_ENABLE_MYPYC"] = "1"
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"black", shell_parameter_format: :click)
  end

  service do
    run opt_bin/"blackd"
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/blackd.log"
    error_log_path var/"log/blackd.log"
  end

  test do
    assert_match "compiled: yes", shell_output("#{bin}/black --version")

    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"black_test.py").write <<~PYTHON
      print(
      'It works!')
    PYTHON
    system bin/"black", "black_test.py"
    assert_equal 'print("It works!")', (testpath/"black_test.py").read.strip

    port = free_port
    spawn bin/"blackd", "--bind-host=127.0.0.1", "--bind-port=#{port}"
    sleep 10
    output = shell_output("curl -s -XPOST localhost:#{port} -d \"print('valid')\"").strip
    assert_match 'print("valid")', output
  end
end

__END__
diff --git a/pyproject.toml b/pyproject.toml
index be6c8f9b9d543221abee109734f038fd3480c8c7..b3e7f2414fa316f06da59fa4a7a00e4a2433c1e8 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -126,7 +126,7 @@ macos-max-compat = true
 enable-by-default = false
 dependencies = [
   "hatch-mypyc>=0.16.0",
-  "mypy>=1.12",
+  "mypy==1.17.1",
   "click>=8.1.7",
 ]
 require-runtime-dependencies = true
diff --git a/src/black/trans.py b/src/black/trans.py
index 0b5956304502991721ea4c2f0838c4c2a285590b..de24d723e1e56a5aca71535f9d572a49a5ad9b8b 100644
--- a/src/black/trans.py
+++ b/src/black/trans.py
@@ -334,6 +334,9 @@ class CustomSplit:
     break_idx: int


+CustomSplitMapKey = tuple[StringID, str]
+
+
 @trait
 class CustomSplitMapMixin:
     """
@@ -342,13 +345,12 @@ class CustomSplitMapMixin:
     the resultant substrings go over the configured max line length.
     """

-    _Key: ClassVar = tuple[StringID, str]
-    _CUSTOM_SPLIT_MAP: ClassVar[dict[_Key, tuple[CustomSplit, ...]]] = defaultdict(
-        tuple
+    _CUSTOM_SPLIT_MAP: ClassVar[dict[CustomSplitMapKey, tuple[CustomSplit, ...]]] = (
+        defaultdict(tuple)
     )

     @staticmethod
-    def _get_key(string: str) -> "CustomSplitMapMixin._Key":
+    def _get_key(string: str) -> CustomSplitMapKey:
         """
         Returns:
             A unique identifier that is used internally to map @string to a
