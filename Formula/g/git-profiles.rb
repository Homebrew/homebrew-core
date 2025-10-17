class GitProfiles < Formula
  include Language::Python::Virtualenv

  desc "Managing Git profiles systemwide"
  homepage "https://github.com/nkaaf/git-profiles"
  url "https://github.com/nkaaf/git-profiles/archive/refs/tags/0.1.0.tar.gz"
  version "0.1.0"
  sha256 "53b291eadaba0084b25473bfc4ef42b803bc174d893c31ec57eb7c5c1740ed92"
  license "Apache-2.0"

  depends_on "python@3.14"
  depends_on "rust" => :build # for pydantic-core

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/78/b6/6307fbef88d9b5ee7421e68d78a9f162e0da4900bc5f5793f6d3d0e34fb8/annotated_types-0.7.0-py3-none-any.whl"
    sha256 "1f02e8b43a8fbbc3f3e0d4f0f4bfc8131bcb4eebe8849b8e5c773f3a1c582a53"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/73/cb/ac7874b3e5d58441674fb70742e6c374b28b0c7cb988d37d991cde47166c/platformdirs-4.5.0-py3-none-any.whl"
    sha256 "e578a81bb873cbb89a41fcc904c7ef523cc18284b7e3b3ccf06aca1403b7ebd3"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/6c/98/468cb649f208a6f1279448e6e5247b37ae79cf5e4041186f1e2ef3d16345/pydantic-2.12.2-py3-none-any.whl"
    sha256 "25ff718ee909acd82f1ff9b1a4acfd781bb23ab3739adaa7144f19a6a4e231ae"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/df/18/d0944e8eaaa3efd0a91b0f1fc537d3be55ad35091b6a87638211ba691964/pydantic_core-2.41.4.tar.gz"
    sha256 "70e47929a9d4a1905a67e4b687d5946026390568a8e952b92824118063cee4d5"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/18/67/36e9267722cc04a6b9f15c7f3441c2363321a3ea07da7ae0c0707beb2a9c/typing_extensions-4.15.0-py3-none-any.whl"
    sha256 "f0fa19c6845758ab08074a0cfa8b7aecb71c999ca73d62883bc25cc018c4e548"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/dc/9b/47798a6c91d8bdb567fe2698fe81e0c6b7cb7ef4d13da4114b41d239f65d/typing_inspection-0.4.2-py3-none-any.whl"
    sha256 "4ed1cacbdc298c220f1bd249ed5287caa16f34d44ef4e9c3d0cbad5b521545e7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    help_output = shell_output("#{bin}/git-profiles --help")
    assert_match "usage:", help_output
  end
end
