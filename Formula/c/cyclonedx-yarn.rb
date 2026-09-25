class CyclonedxYarn < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Yarn projects"
  homepage "https://github.com/CycloneDX/cyclonedx-node-yarn"
  url "https://github.com/CycloneDX/cyclonedx-node-yarn/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "f80e6ace4be86bf929caa6094fd19adb9e2ffe714aa26d756a5884d1d55204c0"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-node-yarn.git", branch: "main"

  depends_on "corepack" => [:build, :test] # for the yarn 4 pinned by `packageManager`
  depends_on "node"

  # The test needs corepack to download the yarn pinned by the fixture
  deny_network_access! :build

  def fetch
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"
    ENV["COREPACK_HOME"] = buildpath/"corepack"
    # `--mode=skip-build` skips compiling the test-only `libxmljs2` native addon
    system "yarn", "install", "--immutable", "--mode=skip-build"
    # Gathers build-time info from the registry, which the bundle embeds
    system "yarn", "build:gbti"
  end

  def install
    ENV["COREPACK_HOME"] = buildpath/"corepack"
    system "yarn", "build:bundle"

    libexec.install "bin", "bundles"
    bin.install_symlink libexec/"bin/cyclonedx-yarn-cli.js" => "cyclonedx-yarn"
  end

  test do
    testbed = "https://raw.githubusercontent.com/CycloneDX/cyclonedx-node-yarn/45c94758223f54b961798cd3c902c710f53dd4df/tests/_data/testbeds/lockfile-only"
    resource "homebrew-package.json" do
      url "#{testbed}/package.json"
      sha256 "4b8feb7d4fd2ecf4abe415cb1579fa53574cf6f8bafecd9f3437ad7ba07d627e"
    end
    resource "homebrew-yarn.lock" do
      url "#{testbed}/yarn.lock"
      sha256 "baf2ad0cdc88073cc1d5be9b3badad9028bac31db058575851aee236871713c7"
    end
    testpath.install resource("homebrew-package.json"), resource("homebrew-yarn.lock")
    (testpath/".yarnrc.yml").write <<~YAML
      enableNetwork: false
      enableGlobalCache: false
      globalFolder: ./.yarn_global
      enableScripts: false
    YAML

    # Corepack downloads the `yarn@4` pinned by `packageManager` in `package.json`
    ENV["COREPACK_HOME"] = testpath/"corepack"
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"
    system bin/"cyclonedx-yarn", "--lockfile-only", "--output-file", "sbom.json"
    assert_match "pkg:npm/is-positive@3.1.0", (testpath/"sbom.json").read
  end
end
