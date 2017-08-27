require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.15-July2017.tar.gz"
  version "0.10.15"
  sha256 "e63b4586b7eae9065839adfee9a613d4a746ae26a78eb033ef69204026039360"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3d18c5026aa6555fa40db8b9edfdae42e7a700a89b6afafca8ef94a6f56fcf3" => :sierra
    sha256 "8c5552016740425360800572e3a14a1f734bfe3d2a874f0e921f95ea69b86d64" => :el_capitan
    sha256 "2fa98a93dd7e2a96f401ab4017a13e58e4b96646d4453b72c9df1e414afbc98f" => :yosemite
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
