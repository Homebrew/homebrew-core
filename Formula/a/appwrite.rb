class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-22.3.0.tgz"
  sha256 "295aea43d875d563e571b004036864e4c5ab4fe77728cf403a364053a0198616"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "55551c5333cb351d97f71e18fdb17944cfee10d93f8617bdc9623fe0fb374a65"
    sha256 cellar: :any,                 arm64_sequoia: "da71a82ae3b0813cdd862f15aedaa5cf26898d2fd56e18ab8e6691ffed61cd28"
    sha256 cellar: :any,                 arm64_sonoma:  "da71a82ae3b0813cdd862f15aedaa5cf26898d2fd56e18ab8e6691ffed61cd28"
    sha256 cellar: :any,                 sonoma:        "80691889a054ab31a84c5fcb455f82e6419ec45e2bf247a779792b771296c56a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2af26078032070d64b4273699558d225f5431e467896b1c8a12e520a3f42da22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9147e6437f7ad3e4cff832725ec141735e401a545906bb66e4e537d4a0c5642c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
