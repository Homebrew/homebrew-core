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
    sha256 "bcae6de202bdd1867a23b40800fa0e533cbc931a54b483c32dc014c1a0a0b0e6" => :el_capitan
    sha256 "0562c1c5224b5f9792f1075cbaad012f1f560e54e12fdb9220dc4e7bd070c138" => :yosemite
    sha256 "8e22e02f516226c07d7cdb0cb51b8a094541d27b5e0dc48da167536447f24a2c" => :mavericks
  end

  depends_on "node"

  def install
    ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"
    # install node dependencies
    system "npm", "install"
    # remove windows stuff
    rm_rf "bin/windows"
    (prefix/"src").install Dir["lib", "node_modules", "package.json", "bin"]
    bin.install_symlink (prefix/"src/bin/azure")
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
