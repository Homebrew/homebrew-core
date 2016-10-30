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
    sha256 "9cf26a81e677604eca510235dee5c114c0d737a9c563063e29640a69016bd65c" => :sierra
    sha256 "52245ebdb1b6dae1025cecdf0275f89d87e8f00861a24dd7276c54b2e8077a00" => :el_capitan
    sha256 "2bcffc313f98a4137df2e368348007fe3b7acfebeb494a59dd3062b7c6f81bc0" => :yosemite
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
