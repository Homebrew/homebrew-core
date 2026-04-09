class Pytr < Formula
  include Language::Python::Virtualenv

  desc "Use TradeRepublic in terminal and mass download all documents"
  homepage "https://github.com/pytr-org/pytr"
  url "https://files.pythonhosted.org/packages/04/c0/173ad027a75b3c1b6705ac56c647c78ed9ec99379e7257adfd42ebd8e30f/pytr-0.4.7.tar.gz"
  sha256 "7b60cbd8fb0f9f623059c42b9a78e751677e1d97726ef834784ff5babd6872e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56c4f938e4b7fbaa9a63514f948535ecb9f24d4672760d4df39adefc3d09f3c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77d1f027ac4e76f5a988f673b97210b4cebbaa3170c24af6eb1741a8bdd4db88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7e08f720be81953dc8f6ee268a769480b94bd4f865404e12e517a5f74f2935c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7c9874e4bb97b67c195a1aabbf6314ece074e12a89ee679603d7ed3bb3ee20b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b70721f04f1fbd576b21913f8b38d34828aee542991f697678ba1003360487e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c0f89a1969a1ac5d0701ac4b787123e5de202783d788ee9e48ba0cd1891d599"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/b2/51899539b6ceeeb420d40ed3cd4b7a40519404f9baf3d4ac99dc413a834b/babel-2.18.0.tar.gz"
    sha256 "b80b99a14bd085fcacfa15c9165f651fbb3406e66cc603abf11c5750937c992d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "curl-cffi" do
    url "https://files.pythonhosted.org/packages/9b/c9/0067d9a25ed4592b022d4558157fcdb6e123516083700786d38091688767/curl_cffi-0.14.0.tar.gz"
    sha256 "5ffbc82e59f05008ec08ea432f0e535418823cda44178ee518906a54f27a5f0f"

    # Backport of upstream libcurl-impersonate build fix, upstream PR 697, https://github.com/lexiforest/curl_cffi/pull/697
    patch :DATA
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/25/ca/8de7744cb3bc966c85430ca2d0fcaeea872507c6a4cf6e007f7fe269ed9d/ecdsa-0.19.2.tar.gz"
    sha256 "62635b0ac1ca2e027f82122b5b81cb706edc38cd91c63dda28e4f3455a2bf930"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pathvalidate" do
    url "https://files.pythonhosted.org/packages/fa/2a/52a8da6fe965dea6192eb716b357558e103aea0a1e9a8352ad575a8406ca/pathvalidate-3.3.1.tar.gz"
    sha256 "b18c07212bfead624345bb8e1d6141cdcf15a39736994ea0b94035ad2b1ba177"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
  end

  resource "requests-futures" do
    url "https://files.pythonhosted.org/packages/88/f8/175b823241536ba09da033850d66194c372c65c38804847ac9cef0239542/requests_futures-1.0.2.tar.gz"
    sha256 "6b7eb57940336e800faebc3dab506360edec9478f7b22dc570858ad3aa7458da"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/b0/7a/7f131b6082d8b592c32e4312d0a6da3d0b28b8f0d305ddd93e49c9d89929/shtab-1.8.0.tar.gz"
    sha256 "75f16d42178882b7f7126a0c2cb3c848daed2f4f5a276dd1ded75921cc4d073a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pytr", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pytr --version")

    output = shell_output(
      "#{bin}/pytr --debug-logfile pytr.log login -n +4912345678 -p 1234 2>&1", 1
    )
    assert_match "Setting up debug logfile pytr.log", output
    assert_path_exists testpath/"pytr.log"
    assert_match "Phone number provided as argument", (testpath/"pytr.log").read
  end
end

__END__
--- a/libs.json
+++ b/libs.json
@@ -5,8 +5,9 @@
         "pointer_size": 64,
         "libdir": "./lib64",
         "sysname": "win32",
-        "so_name": "libcurl.dll",
-        "so_arch": "x86_64"
+        "link_type": "dynamic",
+        "obj_name": "libcurl.dll",
+        "arch": "x86_64"
     },
     {
         "system": "Windows",
@@ -14,8 +15,9 @@
         "pointer_size": 32,
         "libdir": "./lib32",
         "sysname": "win32",
-        "so_name": "libcurl.dll",
-        "so_arch": "i686"
+        "link_type": "dynamic",
+        "obj_name": "libcurl.dll",
+        "arch": "i686"
     },
     {
         "system": "Windows",
@@ -23,113 +25,106 @@
         "pointer_size": 64,
         "libdir": "./libarm64",
         "sysname": "win32",
-        "so_name": "libcurl.dll",
-        "so_arch": "arm64"
+        "link_type": "dynamic",
+        "obj_name": "libcurl.dll",
+        "arch": "arm64"
     },
     {
         "system": "Darwin",
         "machine": "x86_64",
         "pointer_size": 64,
-        "libdir": "/Users/runner/work/_temp/install/lib",
         "sysname": "macos",
-        "so_name": "libcurl-impersonate.4.dylib",
-        "so_arch": "x86_64"
+        "link_type": "static",
+        "obj_name": "libcurl-impersonate.a",
+        "arch": "x86_64"
     },
     {
         "system": "Darwin",
         "machine": "arm64",
         "pointer_size": 64,
-        "libdir": "/Users/runner/work/_temp/install/lib",
         "sysname": "macos",
-        "so_name": "libcurl-impersonate.4.dylib",
-        "so_arch": "arm64"
+        "link_type": "static",
+        "obj_name": "libcurl-impersonate.a",
+        "arch": "arm64"
     },
     {
         "system": "Linux",
         "machine": "x86_64",
         "pointer_size": 64,
-        "libdir": "",
         "sysname": "linux",
         "link_type": "static",
         "libc": "gnu",
-        "so_name": "libcurl-impersonate.so",
-        "so_arch": "x86_64"
+        "obj_name": "libcurl-impersonate.a",
+        "arch": "x86_64"
     },
     {
         "system": "Linux",
         "machine": "x86_64",
         "pointer_size": 64,
-        "libdir": "",
         "sysname": "linux",
         "link_type": "static",
         "libc": "musl",
-        "so_name": "libcurl-impersonate.so",
-        "so_arch": "x86_64"
+        "obj_name": "libcurl-impersonate.a",
+        "arch": "x86_64"
     },
     {
         "system": "Linux",
         "machine": "i686",
         "pointer_size": 32,
-        "libdir": "",
         "sysname": "linux",
         "link_type": "static",
         "libc": "gnu",
-        "so_name": "libcurl-impersonate.so",
-        "so_arch": "i386"
+        "obj_name": "libcurl-impersonate.a",
+        "arch": "i386"
     },
     {
         "system": "Linux",
         "machine": "aarch64",
         "pointer_size": 64,
-        "libdir": "",
         "sysname": "linux",
         "link_type": "static",
         "libc": "gnu",
-        "so_name": "libcurl-impersonate.so",
-        "so_arch": "aarch64"
+        "obj_name": "libcurl-impersonate.a",
+        "arch": "aarch64"
     },
     {
         "system": "Linux",
         "machine": "riscv64",
         "pointer_size": 64,
-        "libdir": "",
         "sysname": "linux",
         "link_type": "static",
         "libc": "gnu",
-        "so_name": "libcurl-impersonate.so",
-        "so_arch": "riscv64"
+        "obj_name": "libcurl-impersonate.a",
+        "arch": "riscv64"
     },
     {
         "system": "Linux",
         "machine": "aarch64",
         "pointer_size": 64,
-        "libdir": "~/.local/lib",
         "sysname": "linux",
-        "link_type": "dynamic",
+        "link_type": "static",
         "libc": "musl",
-        "so_name": "libcurl-impersonate.so",
-        "so_arch": "aarch64"
+        "obj_name": "libcurl-impersonate.a",
+        "arch": "aarch64"
     },
     {
         "system": "Linux",
         "machine": "armv6l",
         "pointer_size": 32,
-        "libdir": "",
         "sysname": "linux",
         "link_type": "static",
         "libc": "gnueabihf",
-        "so_name": "libcurl-impersonate.so",
-        "so_arch": "arm"
+        "obj_name": "libcurl-impersonate.a",
+        "arch": "arm"
     },
     {
         "system": "Linux",
         "machine": "armv7l",
         "pointer_size": 32,
-        "libdir": "",
         "sysname": "linux",
         "link_type": "static",
         "libc": "gnueabihf",
-        "so_name": "libcurl-impersonate.so",
-        "so_arch": "arm"
+        "obj_name": "libcurl-impersonate.a",
+        "arch": "arm"
     }
 ]
--- a/scripts/build.py
+++ b/scripts/build.py
@@ -11,7 +11,7 @@
 from cffi import FFI
 
 # this is the upstream libcurl-impersonate version
-__version__ = "1.2.5"
+__version__ = "1.4.1"
 
 
 def detect_arch():
@@ -33,7 +33,7 @@
             and arch["pointer_size"] == pointer_size
             and ("libc" not in arch or arch.get("libc") == libc)
         ):
-            if arch["libdir"]:
+            if arch.get("libdir"):
                 arch["libdir"] = os.path.expanduser(arch["libdir"])
             else:
                 global tmpdir
@@ -49,12 +49,17 @@
 
 
 arch = detect_arch()
-print(f"Using {arch['libdir']} to store libcurl-impersonate")
+link_type = arch.get("link_type")
+libdir = Path(arch["libdir"])
+is_static = link_type == "static"
+is_dynamic = link_type == "dynamic"
+print(f"Using {libdir} to store libcurl-impersonate")
 
 
 def download_libcurl():
-    if (Path(arch["libdir"]) / arch["so_name"]).exists():
-        print(".so files already downloaded.")
+    expected = libdir / arch["obj_name"]
+    if expected.exists():
+        print(f"libcurl-impersonate: {expected} already downloaded.")
         return
 
     file = "libcurl-impersonate.tar.gz"
@@ -63,46 +68,34 @@
     url = (
         f"https://github.com/lexiforest/curl-impersonate/releases/download/"
         f"v{__version__}/libcurl-impersonate-v{__version__}"
-        f".{arch['so_arch']}-{sysname}.tar.gz"
+        f".{arch['arch']}-{sysname}.tar.gz"
     )
 
     print(f"Downloading libcurl-impersonate from {url}...")
     urlretrieve(url, file)
 
     print("Unpacking downloaded files...")
-    os.makedirs(arch["libdir"], exist_ok=True)
-    shutil.unpack_archive(file, arch["libdir"])
+    os.makedirs(libdir, exist_ok=True)
+    shutil.unpack_archive(file, libdir)
 
     if arch["system"] == "Windows":
-        for file in glob(os.path.join(arch["libdir"], "lib/*.lib")):
-            shutil.move(file, arch["libdir"])
-        for file in glob(os.path.join(arch["libdir"], "bin/*.dll")):
-            shutil.move(file, arch["libdir"])
+        for file in glob(str(libdir / "lib/*.lib")):
+            shutil.move(file, libdir)
+        for file in glob(str(libdir / "bin/*.dll")):
+            shutil.move(file, libdir)
 
-    print("Files after unpacking")
-    print(os.listdir(arch["libdir"]))
+    print("Files after unpacking:")
+    print(os.listdir(libdir))
 
 
 def get_curl_archives():
-    print("Files for linking")
-    print(os.listdir(arch["libdir"]))
-    if arch["system"] == "Linux" and arch.get("link_type") == "static":
+    print("Files in linking directory:")
+    print(os.listdir(libdir))
+    if is_static:
         # note that the order of libraries matters
         # https://stackoverflow.com/a/36581865
         return [
-            f"{arch['libdir']}/libcurl-impersonate.a",
-            f"{arch['libdir']}/libssl.a",
-            f"{arch['libdir']}/libcrypto.a",
-            f"{arch['libdir']}/libz.a",
-            f"{arch['libdir']}/libzstd.a",
-            f"{arch['libdir']}/libnghttp2.a",
-            f"{arch['libdir']}/libngtcp2.a",
-            f"{arch['libdir']}/libngtcp2_crypto_boringssl.a",
-            f"{arch['libdir']}/libnghttp3.a",
-            f"{arch['libdir']}/libbrotlidec.a",
-            f"{arch['libdir']}/libbrotlienc.a",
-            f"{arch['libdir']}/libbrotlicommon.a",
-            f"{arch['libdir']}/libcares.a",
+            str(libdir / arch["obj_name"])
         ]
     else:
         return []
@@ -128,11 +121,8 @@
             "brotlidec",
             "brotlicommon",
             "iphlpapi",
-            "cares",
         ]
-    elif arch["system"] == "Darwin" or (
-        arch["system"] == "Linux" and arch.get("link_type") == "dynamic"
-    ):
+    elif is_dynamic:
         return ["curl-impersonate"]
     else:
         return []
@@ -143,21 +133,38 @@
 root_dir = Path(__file__).parent.parent
 download_libcurl()
 
+# With mega archive, we only have one to link
+static_libs = get_curl_archives()
+extra_link_args = []
+if is_static:
+    if system == "Darwin":
+        extra_link_args = [
+            f"-Wl,-force_load,{static_libs[0]}",
+            "-lc++",
+        ]
+    elif system == "Linux":
+        extra_link_args = [
+            "-Wl,--whole-archive",
+            static_libs[0],
+            "-Wl,--no-whole-archive",
+            "-lstdc++",
+        ]
 
+libraries = get_curl_libraries()
+
 ffibuilder.set_source(
     "curl_cffi._wrapper",
     """
         #include "shim.h"
     """,
-    # FIXME from `curl-impersonate`
+    library_dirs=[str(libdir)],
     libraries=get_curl_libraries(),
-    extra_objects=get_curl_archives(),
-    library_dirs=[arch["libdir"]],
+    extra_objects=[],  # linked via extra_link_args
     source_extension=".c",
     include_dirs=[
         str(root_dir / "include"),
         str(root_dir / "ffi"),
-        str(Path(arch["libdir"]) / "include"),
+        str(libdir / "include"),
     ],
     sources=[
         str(root_dir / "ffi/shim.c"),
@@ -165,7 +172,7 @@
     extra_compile_args=(
         ["-Wno-implicit-function-declaration"] if system == "Darwin" else []
     ),
-    extra_link_args=(["-lstdc++"] if system != "Windows" else []),
+    extra_link_args=extra_link_args,
 )
 
 with open(root_dir / "ffi/cdef.c") as f:
