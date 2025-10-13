class PydanticCore < Formula
  include Language::Python::Virtualenv

  desc "Core functionality for Pydantic validation and serialization"
  homepage "https://github.com/pydantic/pydantic-core"
  url "https://files.pythonhosted.org/packages/00/e9/3916abb671bffb00845408c604ff03480dc8dc273310d8268547a37be0fb/pydantic_core-2.41.3.tar.gz"
  sha256 "cdebb34b36ad05e8d77b4e797ad38a2a775c2a07a8fa386d4f6943b7778dcd39"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0835f8d08862c41a586d622a9bc300fc7d192b6f9affe960716dc90025342d4e"
    sha256 cellar: :any,                 arm64_sequoia: "e302c527c889c295e81d561c8fc9c4f50d805be6292f7ff3bffe293ff4159876"
    sha256 cellar: :any,                 arm64_sonoma:  "38fb30ff701c46471a244bf761d071ac36c54c765f502484d29a99efaa0029c4"
    sha256 cellar: :any,                 sonoma:        "9b0be00237836a31c35e63515c6fdbae6863d8e6fa4fd6a6372abac6e8fed40c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f15ad8e66fb0f290277858daaaf136437ca0936ae75d8d56441365d7e0aff9c9"
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
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    resource "typing-extensions" do
      url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
      sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
    end

    pythons.each do |python3|
      venv = virtualenv_create(testpath/"venv", python3)
      venv.pip_install resource("typing-extensions")
      python = venv.root/"bin/python"
      system python, "-c", "import pydantic_core;"
    end
  end
end
