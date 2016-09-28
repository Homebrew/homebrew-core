require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.5-September2016.tar.gz"
  version "0.10.5"
  sha256 "d4b2040304cad6e29d47f8d08b744e8bab45722af6c1d0d0a99e4ba2a86a22dd"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bb6531031a487651e2e3c9c5a54539be0e786a53b5dd86af456c7396ffca2d9" => :sierra
    sha256 "edd7e418da7602091881eb9bac6b6cb9bedd81964d1ace7a66141aa2c54bc000" => :el_capitan
    sha256 "4517c3c69653d85f03c60eae832380e67d1ca22e28012637b7c2a9d75daf7922" => :yosemite
    sha256 "21ca0fd30b6155d2d353f52091b0fe5c862953ca30332aeef54950036f770f96" => :mavericks
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
