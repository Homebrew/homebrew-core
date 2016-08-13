require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.3-August2016.tar.gz"
  version "0.10.3"
  sha256 "90490475b04e516feae9a2d7793859b1d11bfbefbb0036436e166ea5696e4ec0"

  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "c79b3a95ed9001d285d540b95c402fc8381c0ebd755ef577a957b6359db58726" => :el_capitan
    sha256 "2358dbdb722f04609a17f5368a714ae80df499da4240d1a9500a36651c4db1ff" => :yosemite
    sha256 "e6d195fdfc6eec6875ad0af52ff035a2aa5e7e46ea05dfa3a8a9449029c11992" => :mavericks
  end

  depends_on "node"
  depends_on :python => :build

  def install
    rm_rf "bin/windows"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"azure").write Utils.popen_read("#{bin}/azure --completion")
  end

  test do
    shell_output("#{bin}/azure telemetry --disable")
    json_text = shell_output("#{bin}/azure account env show AzureCloud --json")
    azure_cloud = Utils::JSON.load(json_text)
    assert_equal azure_cloud["name"], "AzureCloud"
    assert_equal azure_cloud["managementEndpointUrl"], "https://management.core.windows.net"
    assert_equal azure_cloud["resourceManagerEndpointUrl"], "https://management.azure.com/"
  end
end
