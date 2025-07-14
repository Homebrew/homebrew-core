class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https://github.com/openai/whisper"
  url "https://files.pythonhosted.org/packages/35/8e/d36f8880bcf18ec026a55807d02fe4c7357da9f25aebd92f85178000c0dc/openai_whisper-20250625.tar.gz"
  sha256 "37a91a3921809d9f44748ffc73c0a55c9f366c85a3ef5c2ae0cc09540432eb96"
  license "MIT"
  head "https://github.com/openai/whisper.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ddbd99e57d4b6d19776eb845a391f8931bbb5e33388fb3bf6e729187e34bc0c"
    sha256 cellar: :any,                 arm64_sonoma:  "9a4150879ebc0737f996fa9db9f01f6754297ea33062fc620bc9c3e329bb9437"
    sha256 cellar: :any,                 arm64_ventura: "e83c8ed541c46dcf5c6d4f3b5af8dcead2737336ea2d56d8d70c289cbdc2b794"
    sha256 cellar: :any,                 sonoma:        "2affb4484990c8b5cb1d8a26eaa1eff042f767d07df3608e462aeffe1303ad33"
    sha256 cellar: :any,                 ventura:       "2a2a57ad2865ddae3533923c430b49e48bfac19b38ca21964c46f294e8e571e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11f8ae38e585df14c4aa677b49377d397d4d0acce45e0719277c611cfe68e9f6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for tiktoken
  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "llvm@16" # LLVM 20 PR: https://github.com/numba/llvmlite/pull/1092
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "pytorch"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "llvmlite" do
    url "https://files.pythonhosted.org/packages/89/6a/95a3d3610d5c75293d5dbbb2a76480d5d4eeba641557b69fe90af6c5b84e/llvmlite-0.44.0.tar.gz"
    sha256 "07667d66a5d150abed9157ab6c0b9393c9356f229784a4385c02f99e94fc94d4"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ce/a0/834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09/more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/1c/a0/e21f57604304aa03ebb8e098429222722ad99176a4f979d34af1d1ee80da/numba-0.61.2.tar.gz"
    sha256 "8750ee147940a6637b80ecf7f95062185ad8726c8c28a2295b8ec1160a196f7d"

    # Support numpy 2.3, upstream issue, https://github.com/numba/numba/issues/10105
    patch :DATA
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/ea/cf/756fedf6981e82897f2d570dd25fa597eb3f4459068ae0572d7e888cfd6f/tiktoken-0.9.0.tar.gz"
    sha256 "d02a5ca6a938e0490e1ff957bc48c8b078c88cb83977be1625b1fd8aac792c5d"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    ENV["LLVM_CONFIG"] = Formula["llvm@16"].opt_bin/"llvm-config"
    venv = virtualenv_install_with_resources without: "numba"

    # We depend on pytorch, but that's a separate formula, so install a `.pth` file to link them.
    # NOTE: This is an exception to our usual policy as building `pytorch` is complicated
    site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    pth_contents = "import site; site.addsitedir('#{Formula["pytorch"].opt_libexec/site_packages}')\n"
    (venv.site_packages/"homebrew-pytorch.pth").write pth_contents

    # We install `numba` separately without build isolation to avoid building another `numpy`
    venv.pip_install(resource("numba"), build_isolation: false)
  end

  test do
    resource "homebrew-test-audio" do
      url "https://raw.githubusercontent.com/openai/whisper/7858aa9c08d98f75575035ecd6481f462d66ca27/tests/jfk.flac"
      sha256 "63a4b1e4c1dc655ac70961ffbf518acd249df237e5a0152faae9a4a836949715"
    end

    resource "homebrew-test-model" do
      url "https://openaipublic.azureedge.net/main/whisper/models/d3dd57d32accea0b295c96e26691aa14d8822fac7d9d27d5dc00b4ca2826dd03/tiny.en.pt"
      sha256 "d3dd57d32accea0b295c96e26691aa14d8822fac7d9d27d5dc00b4ca2826dd03"
    end

    testpath.install resource("homebrew-test-audio")
    (testpath/"models").install resource("homebrew-test-model")
    # for some unknown reason, the file is installed as `tests` rather than `jfk.flac`
    system bin/"whisper", "tests", "--model", "tiny.en", "--model_dir", "models", "--output_format", "txt"
    assert_equal <<~EOS, (testpath/"tests.txt").read
      And so, my fellow Americans ask not what your country can do for you
      ask what you can do for your country.
    EOS
  end
end

__END__
diff --git a/numba/__init__.py b/numba/__init__.py
index ab1081d..44fe64a 100644
--- a/numba/__init__.py
+++ b/numba/__init__.py
@@ -39,8 +39,8 @@ def _ensure_critical_deps():
                f"{numpy_version[0]}.{numpy_version[1]}.")
         raise ImportError(msg)

-    if numpy_version > (2, 2):
-        msg = (f"Numba needs NumPy 2.2 or less. Got NumPy "
+    if numpy_version > (2, 3):
+        msg = (f"Numba needs NumPy 2.3 or less. Got NumPy "
                f"{numpy_version[0]}.{numpy_version[1]}.")
         raise ImportError(msg)

diff --git a/setup.py b/setup.py
index d40c84c..3d407c1 100644
--- a/setup.py
+++ b/setup.py
@@ -23,7 +23,7 @@ min_python_version = "3.10"
 max_python_version = "3.14"  # exclusive
 min_numpy_build_version = "2.0.0rc1"
 min_numpy_run_version = "1.24"
-max_numpy_run_version = "2.3"
+max_numpy_run_version = "2.4"
 min_llvmlite_version = "0.44.0dev0"
 max_llvmlite_version = "0.45"
