class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/2f/7c/20b9289a88e35c2015541ab869c999178d5e4ad2c9dec49544ed0e34ae01/fonttools-4.39.4.zip"
  sha256 "dba8d7cdb8e2bac1b3da28c5ed5960de09e59a2fe7e63bb73f5a59e57b0430d2"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a0ad3d46dd308dd9573d8c8c28251be79091e548a570dc0b0b3bc992f780b51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "209516977111ac8d8fb65ce6dab6692b8cf5590642aae8c927c2a66c7dbd6570"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b51f5710639fc03980811338550bcb2fa1b4966c8b4900e8d6ebe6763d9cfef"
    sha256 cellar: :any_skip_relocation, ventura:        "9af02d7e43c7c7a6277b7bc00e2d417a4d223b0f45ba400b964d5d1a34d0464e"
    sha256 cellar: :any_skip_relocation, monterey:       "efc8761ac37f3f8d07244a9f9e862fe0da1182d099bcbae7e6a904f966a4d33b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcda857bc7629f07931b923be9b4fefd564da0eb3bdb4000ff0ebc492b818997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d7c58859eb3e04133f7aad6bea6d385e0fdbf3f7c4270bdcbc872e2d1df44bf"
  end

  depends_on "python@3.11"

  resource "brotli" do
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
