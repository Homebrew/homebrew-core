class PydanticCore < Formula
  include Language::Python::Virtualenv

  desc "Core functionality for Pydantic validation and serialization"
  homepage "https://github.com/pydantic/pydantic-core"
  url "https://files.pythonhosted.org/packages/df/18/d0944e8eaaa3efd0a91b0f1fc537d3be55ad35091b6a87638211ba691964/pydantic_core-2.41.4.tar.gz"
  sha256 "70e47929a9d4a1905a67e4b687d5946026390568a8e952b92824118063cee4d5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03e07dbfdc8d8af1e28b997b12246eac3ca36c31e3e30ee511537a7100f90353"
    sha256 cellar: :any,                 arm64_sequoia: "1428d96bb50eb9df27fb8802b67f0f0c2e8a1f58593adf918140b398f7d95a6e"
    sha256 cellar: :any,                 arm64_sonoma:  "629ea1f77bd3b2337ed11be11477497e99e7685cf5d02cbf5f264daccfce6243"
    sha256 cellar: :any,                 sonoma:        "7f83e5e52e2f6d831b7eae4a322807486502a26633a9c74217caad25195b41df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5785e0d43e69891af22932b9a7eeef76a49d1b9b184110de680cbd9e009e6034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "846245f7d616a112af9c85c8978851b158543681a0242e1f3818e4ca246dda9a"
  end

  depends_on "maturin" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    pythons.each do |python3|
      resource("typing-extensions").stage do
        system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
      end

      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python3|
      system python3, "-c", "import pydantic_core;"
    end
  end
end
