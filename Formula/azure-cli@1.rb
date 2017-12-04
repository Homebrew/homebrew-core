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
    sha256 "58850f88e434f7a238be5aa61f089bf43e311835c4c0a65abd825decee6a06bb" => :high_sierra
    sha256 "4cea880791dc5662b8c9c83a89b808354ee78e8a2eeff5f0ae3ddcb155cdb899" => :sierra
    sha256 "2bfb37219f6c7643159527c59335e3962eb80bcfa8c033f5e37a598002c318f8" => :el_capitan
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
