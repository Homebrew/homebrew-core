require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.8-December2016.tar.gz"
  version "0.10.8"
  sha256 "4878650f5f7495d852a5fddbf23a6458c386125dc2c3917efbcd8e296572efd3"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "516d45024edabdc427f0385c50f2c83422f188b316b5bf32da24b5bbe875bf41" => :sierra
    sha256 "4e777348f21aca14bc2814ecd288f1d2f7dfa59cb2c53e0be1e6852e31f8c77d" => :el_capitan
    sha256 "411a8248975745e52e09253645602f461a8e5f1fe4ef631f5c0da530d196119f" => :yosemite
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
