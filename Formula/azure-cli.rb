require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.1-June2016.tar.gz"
  version "0.10.1"
  sha256 "a3ad15997e86e33f22179f893ead230a33b6c30784e0f5fdfe8d82839311f8f0"

  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb13ad6285c15e487eb8cbaf2d12a81215158d708062f1097293c90b409a3e32" => :el_capitan
    sha256 "eff5ce464353395fdc3be26e387efcb0457e5ca6fb8b5897b5c6337a470bb153" => :yosemite
    sha256 "acfc00b60417da09c7f712641523d228947ba5f2de50aff70eb85f668acad512" => :mavericks
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
