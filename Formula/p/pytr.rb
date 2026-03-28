class Pytr < Formula
  include Language::Python::Virtualenv

  desc "Use TradeRepublic in terminal and mass download all documents"
  homepage "https://github.com/pytr-org/pytr"
  url "https://files.pythonhosted.org/packages/04/c0/173ad027a75b3c1b6705ac56c647c78ed9ec99379e7257adfd42ebd8e30f/pytr-0.4.7.tar.gz"
  sha256 "7b60cbd8fb0f9f623059c42b9a78e751677e1d97726ef834784ff5babd6872e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c7b4d2c397f423bc28e2be98795fa2ab587ebcd20720a4f06a45be94dc27524"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb9102a2376ca3db0ce3fce3e5620b0bc827fab93c42f18363e050524527ef01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe774571a720d92db32f6570ab1c9da20b07086c28eb588604e499ecb9c86c48"
    sha256 cellar: :any_skip_relocation, sonoma:        "175931d734198f181f35ab6a3017664af84b306910cdb4328f60d8bd93bb37bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e48a5ae37a9299725b68b918361ca6c7bd52450bc85f3dea9539f335808d2904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bce354acff62a70a06a4948ab2f443fefdfb8e9903948efab36a4cb79504da0b"
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

    # Backport of upstream fix for v0.14.0. upstream pr ref, https://github.com/lexiforest/curl_cffi/pull/697
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

    assert_match "NUMBER_INVALID", shell_output(
      "#{bin}/pytr --debug-logfile pytr.log login -n +4912345678 -p 1234 2>&1", 1
    )
    assert_path_exists testpath/"pytr.log"
  end
end

__END__
diff --git a/libs.json b/libs.json
index 5d63db1..03c334d 100644
--- a/libs.json
+++ b/libs.json
@@ -30,8 +30,10 @@
         "system": "Darwin",
         "machine": "x86_64",
         "pointer_size": 64,
-        "libdir": "/Users/runner/work/_temp/install/lib",
+        "libdir": "",
         "sysname": "macos",
+        "link_type": "static",
+        "obj_name": "libcurl-impersonate.a",
         "so_name": "libcurl-impersonate.4.dylib",
         "so_arch": "x86_64"
     },
@@ -39,8 +41,10 @@
         "system": "Darwin",
         "machine": "arm64",
         "pointer_size": 64,
-        "libdir": "/Users/runner/work/_temp/install/lib",
+        "libdir": "",
         "sysname": "macos",
+        "link_type": "static",
+        "obj_name": "libcurl-impersonate.a",
         "so_name": "libcurl-impersonate.4.dylib",
         "so_arch": "arm64"
     },
diff --git a/scripts/build.py b/scripts/build.py
index f40a6f0..ed17fdf 100644
--- a/scripts/build.py
+++ b/scripts/build.py
@@ -50,10 +50,12 @@ def detect_arch():
 
 arch = detect_arch()
 print(f"Using {arch['libdir']} to store libcurl-impersonate")
+obj_name = arch.get("obj_name", arch["so_name"])
+so_arch = arch.get("arch", arch["so_arch"])
 
 
 def download_libcurl():
-    if (Path(arch["libdir"]) / arch["so_name"]).exists():
+    if (Path(arch["libdir"]) / obj_name).exists():
         print(".so files already downloaded.")
         return
 
@@ -63,7 +65,7 @@ def download_libcurl():
     url = (
         f"https://github.com/lexiforest/curl-impersonate/releases/download/"
         f"v{__version__}/libcurl-impersonate-v{__version__}"
-        f".{arch['so_arch']}-{sysname}.tar.gz"
+        f".{so_arch}-{sysname}.tar.gz"
     )
 
     print(f"Downloading libcurl-impersonate from {url}...")
@@ -86,6 +88,10 @@ def download_libcurl():
 def get_curl_archives():
     print("Files for linking")
     print(os.listdir(arch["libdir"]))
+    if arch["system"] == "Darwin" and arch.get("link_type") == "static":
+        return [
+            f"{arch['libdir']}/{obj_name}",
+        ]
     if arch["system"] == "Linux" and arch.get("link_type") == "static":
         # note that the order of libraries matters
         # https://stackoverflow.com/a/36581865
@@ -130,9 +136,11 @@ def get_curl_libraries():
             "iphlpapi",
             "cares",
         ]
-    elif arch["system"] == "Darwin" or (
-        arch["system"] == "Linux" and arch.get("link_type") == "dynamic"
-    ):
+    elif arch["system"] == "Darwin":
+        if arch.get("link_type") == "dynamic":
+            return ["curl-impersonate"]
+        return []
+    elif arch["system"] == "Linux" and arch.get("link_type") == "dynamic":
         return ["curl-impersonate"]
     else:
         return []
@@ -142,6 +150,15 @@ ffibuilder = FFI()
 system = platform.system()
 root_dir = Path(__file__).parent.parent
 download_libcurl()
+extra_objects = get_curl_archives()
+if system == "Darwin" and arch.get("link_type") == "static":
+    extra_objects = []
+    extra_link_args = [
+        f"-Wl,-force_load,{arch['libdir']}/{obj_name}",
+        "-lc++",
+    ]
+else:
+    extra_link_args = ["-lstdc++"] if system != "Windows" else []
 
 
 ffibuilder.set_source(
@@ -151,7 +168,7 @@ ffibuilder.set_source(
     """,
     # FIXME from `curl-impersonate`
     libraries=get_curl_libraries(),
-    extra_objects=get_curl_archives(),
+    extra_objects=extra_objects,
     library_dirs=[arch["libdir"]],
     source_extension=".c",
     include_dirs=[
@@ -165,7 +182,7 @@ ffibuilder.set_source(
     extra_compile_args=(
         ["-Wno-implicit-function-declaration"] if system == "Darwin" else []
     ),
-    extra_link_args=(["-lstdc++"] if system != "Windows" else []),
+    extra_link_args=extra_link_args,
 )
 
 with open(root_dir / "ffi/cdef.c") as f:
