require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.15-July2017.tar.gz"
  version "0.10.15"
  sha256 "b73cd02b386a84cbd378466ee574bb119dbfc35af0b521e64175a79754bd451b"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d2ccc6569274d56a5adb9d3748e15304b55f0c7c8dee5fabc864316bef1a35aa" => :sierra
    sha256 "434133ceb68bdaf77b50966101e5b396c6fe5ec372a88074ea53f9efbbc2e825" => :el_capitan
    sha256 "3fdff5d0b06bef174430471071ef03d5c253f279d33abc38678797a4b618b92f" => :yosemite
  end

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
