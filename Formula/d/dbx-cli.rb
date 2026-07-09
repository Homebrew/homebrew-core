class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.23.tgz"
  sha256 "348c0475bb4e58c3bdf02713488fb64fbcc0384ecf479d20e9c9cd649a295bc0"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "a470ab00a2c8793fb280a135a4efb8ccc93d28a3ed6c3270306d776fce2a9f5c"
    sha256               arm64_sequoia: "80fa387a0120c670ab05c09e2569f607bbd72db72fb496da0e3867ca1b6ce871"
    sha256               arm64_sonoma:  "682e841319533b124ab5b1d2b4e04560ec945677c0bf966edaf9e9d04554f86c"
    sha256               sonoma:        "6a53463eb9d781e5a5e0372744e8f956a1c74ad39852f7b555f0dede44444139"
    sha256 cellar: :any, arm64_linux:   "bc1f652d4170f59e68d50178b0fe6647f0ebf016de01ab0ee67ccd646f50ac3a"
    sha256 cellar: :any, x86_64_linux:  "08511db8e06bd534ec643bad4780400cbbb417d725a04c8fda32ca2167873950"
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
