class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/1c/ba/ec6c77400dd8dd35a6b7d825cd50401c8fbe64c708f7ce7f766fcb2faa09/fonttools-4.37.2.zip"
  sha256 "b6d86ffd0a5f83d3da6a34d5f99a90398638e423cd6a8d93c5808af703432c7f"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2645ecaf4d4b80996373dc84a003d209034fdbf7d6f592f680d4a3d1a7e5b6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "968a4be3c4839338826fda2362eea6447f4bb47964282e97f9267c3ebb2181fc"
    sha256 cellar: :any_skip_relocation, monterey:       "cff7eb5014b606688248ef2536e5b807ff7510df8999c3bc0bd888d085ecfd96"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e9f71de9e5ae7dad5af04dfa3bbb43ff553d4ff1c1f53a5a4a5e693a638c9f3"
    sha256 cellar: :any_skip_relocation, catalina:       "2cd406163d4e482d48dcf4b9a6210b5773787cd572b2a28da47bb526e0c8eb69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d7d950c9cc950ec21cdc6f9d71917e23df2e6936b22113f0db847f64abdc701"
  end

  depends_on "python@3.10"

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
