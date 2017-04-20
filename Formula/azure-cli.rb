require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.12-April2017.tar.gz"
  version "0.10.12"
  sha256 "44cebf1d0dd85bd313cb6c8c336546d19380a3326b4112d23eb7a59ea9fc7b4d"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "952ca68755e683023f17f350f11dbc870e0f24ea121adb8fc2d009ae5657b8e5" => :sierra
    sha256 "d334aceb873c334bd9b5066d783b50008fa1f81f2092bb0b857a4b5d76e2b87a" => :el_capitan
    sha256 "8a0aa8faf62a049c5a2b3ad0699585420823a5480c2414f882a8dd36688b14e7" => :yosemite
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
