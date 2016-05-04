require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"

  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  stable do
    url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.0-May2016.tar.gz"
    version "0.10.0"
    sha256 "d703af982daaa44253db177f0816bda9951844fd2ca7a96139f9c79a5e28a8db"
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "eb2d3bdf148b0d5d13be5800470a3f17e9718f75084bdbf0334640528b4c75c6" => :el_capitan
    sha256 "ce2ccac2be213d123f1ed7e72627d05ea34d2184a15fb6e7d6739c3a40a7e292" => :yosemite
    sha256 "ee86e87e4f8a18f0f807802625e9d6774d013178292dba94355d59651a111bf7" => :mavericks
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
