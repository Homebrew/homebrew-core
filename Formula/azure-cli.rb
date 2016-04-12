require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  revision 1

  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  stable do
    url "https://github.com/Azure/azure-xplat-cli/archive/v0.9.20-April2016.tar.gz"
    version "0.9.20"
    sha256 "c2b97a6dba7deac3d7cb030602bc84ac0af355fc95f74901bd6c8fa43d5f5da8"

    # Fixes for Node v6. Can be removed on next stable azure-cli release.
    patch do
      url "https://github.com/Azure/azure-xplat-cli/commit/241493584534d2.diff"
      sha256 "2abafa41959c518ea3cb0d2c958c13220b78be3847152f0d28942185afd93c6d"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "79f03aa46d772bbcdb0fdfe1690370d482e04ce1a57770a8324f8bcf5d44035d" => :el_capitan
    sha256 "95095ad262172e48c2af2c43641a3b91573b1d6f2539d44ae4d04c2de552fdf8" => :yosemite
    sha256 "667e4b13f85b636ecec675d490d123f633c29bb25b41db8cb2ef9babc08141c3" => :mavericks
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
