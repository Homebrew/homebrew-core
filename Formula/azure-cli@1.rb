require "language/node"

class AzureCliAT1 < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.15-July2017.tar.gz"
  version "1.0.10.15"
  sha256 "b73cd02b386a84cbd378466ee574bb119dbfc35af0b521e64175a79754bd451b"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "650ffe0ac2def8a31931e75ef2d78345f89dca265bf8444de5311692d36c1913" => :high_sierra
    sha256 "655a9111da858348910dbc4015851c9d1e0be73a9b7c7dd6660c117fb8f965f6" => :sierra
    sha256 "8fcba4260673571b03bd2305d7c5de937de8d7f1569d65475104240f26643773" => :el_capitan
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
