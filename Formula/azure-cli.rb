require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.2-July2016.tar.gz"
  version "0.10.2"
  sha256 "490290c628ca2ad36a006f4c689511d0950613909e80f3eb595471f84fd17c8f"

  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c6bd17f7485b7e9f2aaca4f7860a5da2047799e003212b647c66c352509dad6" => :el_capitan
    sha256 "35429759c01405f67a9c01644d8acfd8d4b7296dc6929c7d5c1a100c80921b1f" => :yosemite
    sha256 "fbabbf188ec247349a66cae1e4b422682f5e5c2626c09cc56390f1841140e5f5" => :mavericks
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
