class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/9a/08/7012b00a9a5874311b639c3920270c36ee0c445b69d9989a85e5c92ebcb0/fonttools-4.62.1.tar.gz"
  sha256 "e54c75fd6041f1122476776880f7c3c3295ffa31962dc6ebe2543c00dca58b5d"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0001eade086c988cc672a9af2c8d2038f960dab53e142be6cc36c0a27528f503"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bfca89bd45e458aaeb6f4eb1cc6d51537e3512f50c166f13bc48062c5e21f1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fffee9a93cbd3c1fbaf9da2df0962dde4a0f9c7c219770e519913944473f14f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8a3eca0b7071caedcd3df47db52c9f9eb75f557a25f1121120dddb33fd33a01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b96504a66b7fa25e346f7eb239e035469bacb53517373d52f7395b6326da04d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e40c0be7be38a9772da15b050a7ee38a350f055141889a985646b569cff30e0"
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
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
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
