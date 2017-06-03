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
    rebuild 1
    sha256 "3d9cce38a38527dda6131d937e22c5ead62e071b7dfafc49f2f6eb3123bba0aa" => :sierra
    sha256 "6f892658bd3cb909822027352e8826eefd7c9258d9b3488513526da0995d8af7" => :el_capitan
    sha256 "a9301281b69223213f638fc92b99a4f8032fd354464adfe30d5031664ad4af75" => :yosemite
  end

  depends_on "node"
  depends_on :python => :build

  def install
    rm_rf "bin/windows"

    # Workaround for incorrect file system permissios inside the npm published
    # easy_table@0.0.1 package, which would break build with npm@5.
    # See: https://github.com/Azure/azure-xplat-cli/issues/3605
    inreplace "package.json", '"easy-table": "0.0.1",',
              '"easy-table": "https://github.com/eldargab/easy-table/archive/v0.0.1.tar.gz",'

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
