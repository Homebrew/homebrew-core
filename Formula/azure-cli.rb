require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.12-May2017.tar.gz"
  version "0.10.13"
  sha256 "60194e770b8dca0485db9d4c99f9cd432f7b43096cc5ad0353f52fd5b1b29181"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "0849685ed65f1bfa991c3ffbfaa281f9051d33b626b79b12b1f5341f5925976d" => :sierra
    sha256 "6bcf4ea33dad69d8c703724e09468e08c98d053456fb41a94f6b5877d9a8c243" => :el_capitan
    sha256 "16184e20ae089b157c2e513c1b194ace66d1f46da5eb2869fb9261b1f71aaf1f" => :yosemite
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
