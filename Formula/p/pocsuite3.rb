class Pocsuite3 < Formula
  include Language::Python::Virtualenv

  desc "Open-sourced remote vulnerability testing framework"
  homepage "https://pocsuite.org/"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/knownsec/pocsuite3.git", branch: "master"

  stable do
    url "https://files.pythonhosted.org/packages/0f/05/b17921332ab312c04ccc67b3d01a0d4318a4d45eb0315531f66d41a89639/pocsuite3-2.0.8.tar.gz"
    sha256 "9508ffec49519e5421f19472a582d747b44bf3db289357ed39227e9addfceec3"

    # Drop setuptools dep: https://github.com/knownsec/pocsuite3/pull/420
    patch do
      url "https://github.com/knownsec/pocsuite3/commit/cddfbdb6b7df51f985abe8db7ecd24d5d3b5a92a.patch?full_index=1"
      sha256 "b1aff714f6002b46c2687354ce51ce0f917d5d13beb20fb175f3927f673f9163"
    end

    # Fix SyntaxWarning's: https://github.com/knownsec/pocsuite3/pull/420
    patch do
      url "https://github.com/knownsec/pocsuite3/commit/2505bc8b1501866b9193398575c5653614e131f4.patch?full_index=1"
      sha256 "656929162b5ddd99ae7d98a4580e9dab8914bf0c66f23ab1d7aacb0c2b13a84c"
    end

    # Backport of https://github.com/knownsec/pocsuite3/commit/a632e4986d01adaacb5cd363261bbc4bbdf666d8
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "148dce91ced8405367b6758e0d47bb9a2f41cfc6fa1b9c20049b6f712e2a5c1d"
    sha256 cellar: :any,                 arm64_sonoma:  "e62ec6439b38aa364a77482c242578e9b89f5cb7ea83bd85a274d4a4e0ba411b"
    sha256 cellar: :any,                 arm64_ventura: "c72deb8b5e16df341d216141b9bee62fa211413781b3c2d935c9c7bbe07c9d8a"
    sha256 cellar: :any,                 sonoma:        "6f86e39cb3b17ff2c3a2fd19df02325958527450c23fac2f0197ac3dab01ce9d"
    sha256 cellar: :any,                 ventura:       "09a8bb0237f9a8a2dd8fc61ab3617b734dcb26fd39b6240becc9a2e15bc50afb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9c5ba490de8b4677b999d77b38ec7925f935e055bdf697d0a1862c4ec5062c7"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkgconf" => :build
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/d3/7a/359f4d5df2353f26172b3cc39ea32daa39af8de522205f512f458923e677/colorlog-6.9.0.tar.gz"
    sha256 "bfba54a1b93b94f54e1f4fe48395725a3d92fd2a4af702f6bd70946bdc0c6ac2"
  end

  resource "dacite" do
    url "https://files.pythonhosted.org/packages/21/0f/cf0943f4f55f0fbc7c6bd60caf1343061dff818b02af5a0d444e473bb78d/dacite-1.8.1-py3-none-any.whl"
    sha256 "cc31ad6fdea1f49962ea42db9421772afe01ac5442380d9a99fcf3d188c61afe"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "faker" do
    url "https://files.pythonhosted.org/packages/9c/50/48ab6ba3f07ee7d0eac367695aeb8bc9eb9c3debc0445a67cd07e2d62b44/faker-33.3.1.tar.gz"
    sha256 "49dde3b06a5602177bc2ad013149b6f60a290b7154539180d37b6f876ae79b20"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jq" do
    url "https://files.pythonhosted.org/packages/ba/32/3eaca3ac81c804d6849da2e9f536ac200f4ad46a696890854c1f73b2f749/jq-1.8.0.tar.gz"
    sha256 "53141eebca4bf8b4f2da5e44271a8a3694220dfd22d2b4b2cfb4816b2b6c9057"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "mmh3" do
    url "https://files.pythonhosted.org/packages/e2/08/04ad6419f072ea3f51f9a0f429dd30f5f0a0b02ead7ca11a831117b6f9e8/mmh3-5.0.1.tar.gz"
    sha256 "7dab080061aeb31a6069a181f27c473a1f67933854e36a3464931f2716508896"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/3b/8a/de4dc1a6098621781c266b3fb3964009af1e9023527180cb8a3b0dd9d09e/prettytable-3.12.0.tar.gz"
    sha256 "f04b3e1ba35747ac86e96ec33e3bb9748ce08e254dc2a1c6253945901beec804"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/11/dc/e66551683ade663b5f07d7b3bc46434bf703491dbd22ee12d1f979ca828f/pycryptodomex-3.21.0.tar.gz"
    sha256 "222d0bd05381dd25c32dd6065c071ebf084212ab79bab4599ba9e6a3e0009e6c"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/9f/26/e25b4a374b4639e0c235527bbe31c0524f26eda701d79456a7e1877f4cc5/pyopenssl-25.0.0.tar.gz"
    sha256 "cd2cef799efa3936bb08e8ccb9433a575722b9dd986023f1cabc4ae64e9dac16"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "scapy" do
    url "https://files.pythonhosted.org/packages/df/2f/035d3888f26d999e9680af8c7ddb7ce4ea0fd8d0e01c000de634c22dcf13/scapy-2.6.1.tar.gz"
    sha256 "7600d7e2383c853e5c3a6e05d37e17643beebf2b3e10d7914dffcc3bc3c6e6c5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/37/72/88311445fd44c455c7d553e61f95412cf89054308a1aa2434ab835075fc5/termcolor-2.5.0.tar.gz"
    sha256 "998d8d27da6d48442e8e1f016119076b690d962507531df4890fcd2db2ef8a6f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Module (pocs_ecshop_rce) options:", shell_output("#{bin}/pocsuite -k ecshop --options")
  end
end

__END__
diff --git a/pocsuite3/modules/listener/bind_tcp.py b/pocsuite3/modules/listener/bind_tcp.py
index e7143daa..b554201e 100644
--- a/pocsuite3/modules/listener/bind_tcp.py
+++ b/pocsuite3/modules/listener/bind_tcp.py
@@ -4,7 +4,6 @@
 import pickle
 import base64
 import select
-import telnetlib
 import threading
 from pocsuite3.lib.core.poc import POCBase
 from pocsuite3.lib.utils import random_str
@@ -25,25 +24,18 @@ def read_inputs(s):
     return b''.join(buffer)
 
 
+def read_until(conn, inputs):
+    try:
+        while True:
+            msg = conn.recv(1024).decode('utf-8', errors='ignore')
+            if inputs in msg.lower():
+                break
+    except Exception:
+        pass
+
+
 def read_results(conn, inputs):
-    if isinstance(conn, telnetlib.Telnet):
-        flag = random_str(6).encode()
-        inputs = inputs.strip() + b';' + flag + b'\n'
-        results = b''
-        conn.write(inputs)
-        count = 10
-        while count:
-            count -= 1
-            chunk = conn.read_until(random_str(6).encode(), 0.2)
-            if len(chunk) > 0:
-                results += chunk
-            if results.count(flag) >= 2:
-                # remove the Telnet input echo
-                results = results.split(inputs.strip())[-1]
-                results = os.linesep.encode().join(
-                    results.split(flag)[0].splitlines()[0:-1])
-                return results.strip() + b'\n'
-    elif callable(conn):
+    if callable(conn):
         results = conn(inputs.decode())
         if not isinstance(results, bytes):
             results = results.encode()
@@ -116,15 +108,16 @@ def bind_tcp_shell(host, port, check=True):
 
 
 def bind_telnet_shell(host, port, user, pwd, check=True):
+    # see https://peps.python.org/pep-0594/#telnetlib
     if not check_port(host, port):
         return False
     try:
-        tn = telnetlib.Telnet(host, port)
-        tn.expect([b'Login: ', b'login: '], 10)
-        tn.write(user.encode() + b'\n')
-        tn.expect([b'Password: ', b'password: '], 10)
-        tn.write(pwd.encode() + b'\n')
-        tn.write(b'\n')
+        tn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
+        tn.connect((host, port))
+        read_until(tn, 'login: ')
+        tn.sendall((user + "\n").encode('utf-8'))
+        read_until(tn, 'password: ')
+        tn.sendall((pwd + "\n").encode('utf-8'))
         if check:
             flag = random_str(6).encode()
             if flag not in read_results(tn, b'echo %s' % flag):
