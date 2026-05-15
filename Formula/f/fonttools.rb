class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/9a/08/7012b00a9a5874311b639c3920270c36ee0c445b69d9989a85e5c92ebcb0/fonttools-4.62.1.tar.gz"
  sha256 "e54c75fd6041f1122476776880f7c3c3295ffa31962dc6ebe2543c00dca58b5d"
  license "MIT"
  revision 1
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5e9d042a2f3b8affe6b26fe47a2c2888c3fe6d0c3f3f7471ff7a2d3f485f6fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c2d2dda00716a09061fc0ae5e4e5a2e1c1bdcdae37c23874aad8cc0f66362c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26eb590d85594bc421ec8a4cd95ad119abddb7b4940be509900a08aecb9e8499"
    sha256 cellar: :any_skip_relocation, sonoma:        "08a78111912250c5bb3e6b652596a9184002c84a45167292d49adb2602c3ed9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c45b1aedd915c79e55c915b62bfb9130e822edfc610ddb7f46757bff32a0949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca115bd6504c88fb31868b3b009416f343fe43899e69a25eb1f6458f2d2341cc"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages package_name: "fonttools[lxml,woff]"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/0a/4d/a8cc1768b2eda3c0c7470bf8059dcb94ef96d45dd91fc6edd29430d44072/zopfli-0.4.1.tar.gz"
    sha256 "07a5cdc5d1aaa6c288c5d9f5a5383042ba743641abf8e2fd898dcad622d8a38e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.ttx"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.woff2"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
