require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.10-February2017.tar.gz"
  version "0.10.10"
  sha256 "e26571e2e2ef781c373f543ec2c7c7bafbf503b9525681ce4b45fd799db09eb5"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "8647ed163eb8f00d4aa477f0420dcd4d57ae4043568bc067d27fba2293191051" => :sierra
    sha256 "4c6e63e72da60b23f9612b8282b1173106082050b6e4f63f84a525c5cc236395" => :el_capitan
    sha256 "b1b5921132f84ff3c144d56a80b6102a8564a0b64fa65ad383c592b51cee9b7e" => :yosemite
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
