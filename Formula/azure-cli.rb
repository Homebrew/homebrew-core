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
    sha256 "6b351c20a549ab49bff1dbaf27947886b4bb34496c2c35c171857e2f8bdf4269" => :sierra
    sha256 "575146c65051ad05c1695149314a9b4279b17c6445588326fa20891f3878c272" => :el_capitan
    sha256 "f012fc50a583681897280bd79254b4e67fca415b89736b03a9129ebffd859040" => :yosemite
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
