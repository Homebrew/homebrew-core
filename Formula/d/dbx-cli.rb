class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.14.tgz"
  sha256 "a7510bd14910693d99ee95d57d98798ade2211a09900ffd4528c68a10ada96cb"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "bfc259c8dd7e845cb600d5f40c5f5ee7f63350fc9463c1da861c21402547f966"
    sha256               arm64_sequoia: "88a08030168a79eac50460630ddf8c965233eed0c341b1bc77f8ee1dc5bec436"
    sha256               arm64_sonoma:  "8b8b9e01e5da8a24961cca4f8117e6ebddc82e4197ec9a6b8847e4f283fa1bc3"
    sha256               sonoma:        "0767861e8fd62207239766d2634b24668b93cb7cf8c0d821068526e0e01bee30"
    sha256 cellar: :any, arm64_linux:   "4e61ee71952ada0be6f21131b59354ef736e74b6bbf7482031b99d479fef223b"
    sha256 cellar: :any, x86_64_linux:  "4796f854ae34065a4c0475e91922b64e44c1f65167101ec789019cc463a51c0d"
  end

  depends_on "node"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Rebuild better-sqlite3 and keytar native bindings for the current platform.
    # prebuild-install is blocked by the Homebrew sandbox during npm install,
    # so we must rebuild them explicitly via node-gyp.
    node_modules = libexec/"lib/node_modules/@dbx-app/cli/node_modules"

    cd node_modules/"better-sqlite3" do
      system "npm", "run", "build-release"
    end

    cd node_modules/"keytar" do
      rm_r "prebuilds" if File.directory?("prebuilds")
      system "npm", "run", "build"
    end
  end

  test do
    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end
