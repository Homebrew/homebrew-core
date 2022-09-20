class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/c1/0d/d41b9c2295e1896f4c89e6b213790eee8e8e641b3e9709518f2bddcdeffa/fonttools-4.37.3.zip"
  sha256 "f32ef6ec966cf0e7d2aa88601fed2e3a8f2851c26b5db2c80ccc8f82bee4eedc"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59f641d9cc95da9a7467e4883b3fd91df2d8d48f2b7141ed732d8cfc6e30f9c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f20fc47fb0d7a923ac9a7b35a3425c232108698154ef221fcd38e1ce4a9986e"
    sha256 cellar: :any_skip_relocation, monterey:       "73ff11420ef7f7273e30026482a9070aa499f2318d073975668be759c2c72b1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "92b5c529f2f4a4e8f4dcdca76850adab59e8a37d4060a4c09fb9aaec5d32cd24"
    sha256 cellar: :any_skip_relocation, catalina:       "aaa20068e37d7375b8c5e784e0d6af2974c5238aa630a9f5f87da0a95c164ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "613e5f237fad5b7e4c72dcae46ee8aa492617d3891bcb3d920477ca748802958"
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
