class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.31.tgz"
  sha256 "a5c08e5e7c1bd9e8033df24d1149fdd61450e30e9ba8dd1f509c57e0f14cbea4"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "9224dbf931dfeb233319f6ef01bc2e555dbbb7b17a571cb2969a7a3d78a2bb06"
    sha256               arm64_sequoia: "bdc8a7996a46e88bfb201052bdd150f72875c182f0f09fe7797a0b294ad59c8c"
    sha256               arm64_sonoma:  "25a77336a67834e9610ae33e7731e13b0d292ac554f414ddea8acd9951c4636c"
    sha256               sonoma:        "89994b8887f67091cd7920df0deded3d69c962f2f239df2588dc56201783aeab"
    sha256 cellar: :any, arm64_linux:   "6075273a33ec875a0cf061ec839f0a4587035847236d21142072be36593f6b10"
    sha256 cellar: :any, x86_64_linux:  "9701437f6d6b800eca15542d5ef8401a0cfa577f0dfae6bdd8328a4e73c5b623"
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
