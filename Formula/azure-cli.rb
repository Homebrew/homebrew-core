require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.7-November2016.tar.gz"
  version "0.10.7"
  sha256 "4015616bd3a95ec319db4e3e098bf7251120123528d34d1dcc985834057cf531"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9230a0528af769a635bb36332b8f8840919b494d3b1f62791283f8fddfe2b52" => :sierra
    sha256 "cb1dd8efa04bb98fcb761a1b9a68e10ec0f7e1e79ccb3722cd6f92d9d4e07937" => :el_capitan
    sha256 "672dc427f88b4cd57bee9a54d0bc84b16479b97178018ea2ff8651ccea5765ad" => :yosemite
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
