require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.6-October2016.tar.gz"
  version "0.10.6"
  sha256 "a7cbbc5e31328bfaec17af14f50752a4f54e41df360f4a36aa57091f9c24de49"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5fc36157df2bcb1db389bbe67fc2265d298628ce12f9e0f07ec958ef0bcb2c3" => :sierra
    sha256 "0bd7083e234fa22231527c7b38c902627241d3859445d61e21ab972d1efde1d1" => :el_capitan
    sha256 "f55f24602ce8df06d2aaaf0d6130e616104d06c9fcc6d1f278c14890159d018d" => :yosemite
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
