require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.11-March2017.tar.gz"
  version "0.10.11"
  sha256 "23100401af5d972d2a6c242968a65ae6006b64e74c8b83d27df21c38e7dfd270"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac6da9c636cdbd71ab22e78c5e6c61a9549a4627c72559a014edc482399b06db" => :sierra
    sha256 "8d712f455cead57f06048c9ace136e4b24a3a4d4b76eb16ab3ec382e8f82cf0c" => :el_capitan
    sha256 "64a34158951182b0d2bd935802a234d3e0daa495b737274982f38e8dbbe08385" => :yosemite
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
    azure_cloud = JSON.parse(json_text)
    assert_equal azure_cloud["name"], "AzureCloud"
    assert_equal azure_cloud["managementEndpointUrl"], "https://management.core.windows.net"
    assert_equal azure_cloud["resourceManagerEndpointUrl"], "https://management.azure.com/"
  end
end
