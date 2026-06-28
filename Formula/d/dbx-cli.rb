class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.15.tgz"
  sha256 "d233acd0d0b89c5aa9c839e616f2fb5560efc402128b14791b4e03cf1ebd6ab2"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "4365610db0051422491327bda02c2146f30957556566e44607f029bf8f55da45"
    sha256               arm64_sequoia: "c46d1b596faad7abf5a8452084dfb28a30102e4c6d25e4f5296b5292626d22af"
    sha256               arm64_sonoma:  "99c65626f5299d4e4216abce46e56c097ec35c974a135b019d99abf748dda4e5"
    sha256               sonoma:        "95eb71820d43a2214dca8354485186ce93212563e2a38b4798cc72d895c9bd2a"
    sha256 cellar: :any, arm64_linux:   "04b6a2bd391672dfcd54357cc9553c52cdc6a0c2d2e5b11c658e8cb3ef4e5805"
    sha256 cellar: :any, x86_64_linux:  "d7e2687ee017c2f4cccced2c50c194806a504783b589adb6bc5cd1eb572812bb"
  end

  livecheck do
    url "https://registry.npmjs.org/@dbx-app/cli/latest"
    regex(/"version":"(\d+(?:\.\d+)+)"/i)
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
