class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/1c/77/34ebed84736dacbf164617794c15cd9271c18773cf32eeb7086c8b7b6dfd/langgraph_cli-0.4.24.tar.gz"
  sha256 "8f05f0aec38a5da3cb0e7250123530e83c0179d74be0021050bc5cd36ac0dafb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38fbb0baae920cd95a32f8b98bd6777010b9cd0c0aaf7eb0950a65d2ace306d8"
    sha256 cellar: :any,                 arm64_sequoia: "defbaec567de84e5c1298b287e9a8a8ecbf0c0237cac76bf6a17eac6c4a6a750"
    sha256 cellar: :any,                 arm64_sonoma:  "e7f6bd69c66d2eaadaa844611eae12dd18bdd5bc74272b4d9ea7d1172bd7b9a5"
    sha256 cellar: :any,                 sonoma:        "9c5926d4e7883960d1358b5e9f697c14d19514d34be9c9f9d5fe4bef682ad98a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c38a76e22348fedb1d645380960e72f067829683b9ed87581bfa8cfa232f39d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36202e04ee85a6a47157abf95595ab8cae5c868d89effb396623d97d827f8f17"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi",
                extra_packages:   "typing-extensions" # TODO: Check it can be removed

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
  end

  resource "langgraph-sdk" do
    url "https://files.pythonhosted.org/packages/0e/db/77a45127dddcfea5e4256ba916182903e4c31dc4cfca305b8c386f0a9e53/langgraph_sdk-0.3.13.tar.gz"
    sha256 "419ca5663eec3cec192ad194ac0647c0c826866b446073eb40f384f950986cd5"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/9d/1b/2024d06792d0779f9dbc51531b61c24f76c75b9f4ce05e6f3377a1814cea/orjson-3.11.8.tar.gz"
    sha256 "96163d9cdc5a202703e9ad1b9ae757d5f0ca62f4fa0cc93d1f27b0e180cc404e"

    # Remove nightly feature flag, Rust 1.95 is now stable
    patch :DATA
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/fa/36/e27608899f9b8d4dff0617b2d9ab17ca5608956ca44461ac14ac48b44015/pathspec-1.0.4.tar.gz"
    sha256 "0210e2ae8a21a9137c0d470578cb0e595af87edaa6ebf12ff176f14a02e0e645"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"langgraph", shell_parameter_format: :click)
  end

  test do
    (testpath/"graph.py").write <<~PYTHON
      from langgraph.graph import StateGraph
      builder = StateGraph(list)
      builder.add_node("anode", lambda x: ["foo"])
      builder.add_edge("__start__", "anode")
      graph = builder.compile()
    PYTHON

    (testpath/"langgraph.json").write <<~JSON
      {
        "graphs": {
          "agent": "graph.py:graph"
        },
        "env": {},
        "dependencies": ["."]
      }
    JSON

    system bin/"langgraph", "dockerfile", "DOCKERFILE"
    assert_path_exists "DOCKERFILE"
    dockerfile_content = File.read("DOCKERFILE")
    assert_match "FROM", dockerfile_content, "DOCKERFILE should contain 'FROM'"
  end
end

__END__
--- a/src/lib.rs
+++ b/src/lib.rs
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: MPL-2.0
 // Copyright ijl (2018-2026)
 
-#![cfg_attr(feature = "cold_path", feature(cold_path))]
 #![cfg_attr(feature = "generic_simd", feature(portable_simd))]
 #![cfg_attr(feature = "optimize", feature(optimize_attribute))]
 #![allow(unused_features)] // portable_simd on universal2 cross-compile
