require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.1-June2016.tar.gz"
  version "0.10.1"
  sha256 "a3ad15997e86e33f22179f893ead230a33b6c30784e0f5fdfe8d82839311f8f0"

  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "74c7c60781730f5c91f65f8b03cc033163ca485000a4c18e6f3005b63006efa0" => :el_capitan
    sha256 "8c6eae52995f74e33b93a4dc73da088de7cf7ed290520300f0a23b0ad62f7965" => :yosemite
    sha256 "9426dc8da9b9325c0142001ecb3276f8626a668d90d4aacb8376d11c246ec898" => :mavericks
  end

  depends_on "node"
  depends_on :python => :build

  def install
    rm_rf "bin/windows"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"azure").write `#{bin}/azure --completion`
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
