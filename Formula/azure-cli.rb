require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.14-June2017.tar.gz"
  version "0.10.14"
  sha256 "3a74f8007a53c625c939be21703183130ebc086462674ba66c9c5988f24d3dc4"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "5da09ce76738480b12c23090359685475fdf26b81d741f794b8e1d94860c9268" => :sierra
    sha256 "dcd04f095c2e28b3fb97a987ed76f91fe38fb19b46856242cd55816b955181f0" => :el_capitan
    sha256 "91676bc0e163c0de09cb16c83a4121596f6054d2706397c8a4bfeec40c58b43e" => :yosemite
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
