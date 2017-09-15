require "language/node"

class AzureCliAT1 < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.15-July2017.tar.gz"
  version "1.0.10.15"
  sha256 "b73cd02b386a84cbd378466ee574bb119dbfc35af0b521e64175a79754bd451b"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  depends_on "node"
  depends_on :python => :build

  def install
    rm_rf "bin/windows"

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"azure").write Utils.popen_read("#{bin}/azure --completion")

    # fix cxxstdlib warnings caused by installed (but not used) prebuild binaries for fibers
    rm_rf Dir[libexec/"lib/node_modules/azure-cli/node_modules/fibers/bin/*-{46,48}"]
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
