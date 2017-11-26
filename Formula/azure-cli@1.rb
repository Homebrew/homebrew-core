require "language/node"

class AzureCliAT1 < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/releases/download/v0.10.17-November2017/azure-cli-0.10.17.tar.gz"
  version "1.0.10.17"
  sha256 "b6dedbeacf186ac437c7f5c54b294619ca7bc07ac244aa296f4c4841226e885f"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f50d09bd08557c37a607857326c37ac16efbd1905378079b74a719df3f69b22" => :high_sierra
    sha256 "3fbb6cc6377a35615f6ff744caecb2ad0665f5b1bb82362e05ef798f6a46f2e8" => :sierra
    sha256 "63d301a66f07c2a2b710323e06ec6f695cb041d108de69c12ad15a208e899942" => :el_capitan
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
