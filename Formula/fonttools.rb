class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/55/5c/a4a25cf6db42d113d8f626901bb156b2f7cf7c7564a6bbc7b5cd6f7cb484/fonttools-4.38.0.zip"
  sha256 "2bb244009f9bf3fa100fc3ead6aeb99febe5985fa20afbfbaa2f8946c2fbdaf1"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adf010de711f8644ec23539e4ac5974b414868a53f02b2ee5f38d2c057d669ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12b9422de86b9acb838f84fb1d054f848df1554169d848526c577f8222217564"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "518a1b96e5c907f4b38c33bedd104ef0c773a9b446c6f5a4c29113cc30134eb5"
    sha256 cellar: :any_skip_relocation, ventura:        "cf01c606c615856f589fbed5c7f6c171c18e276c7f99bb1217dad2478598582e"
    sha256 cellar: :any_skip_relocation, monterey:       "07338b9af054e8afa10d396f70d60be4592985352ce48dbcc1f9e7674d5d7c8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "23dccf78c7c582b2c97f3a579b80cfc319be91f3bce82e475091c922a5ef0434"
    sha256 cellar: :any_skip_relocation, catalina:       "64194945854d76fc5d14064ea63f9946e014bdbc71c306255eb9199a6ba40b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "741537411e9bce424ed4a2f4ba9fe758800d8fa757b1249545f680f3958991af"
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
