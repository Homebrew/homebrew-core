class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-23.0.0.tgz"
  sha256 "ed87d7459612650841206c9d975f18bb7054005f68093d05e9d5928ac1ce5df0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ef49baff97eb68d21177930418c38c5ecb567d23adf96514fa08fbbdbd800af7"
    sha256 cellar: :any,                 arm64_sequoia: "ef49baff97eb68d21177930418c38c5ecb567d23adf96514fa08fbbdbd800af7"
    sha256 cellar: :any,                 arm64_sonoma:  "ef49baff97eb68d21177930418c38c5ecb567d23adf96514fa08fbbdbd800af7"
    sha256 cellar: :any,                 sonoma:        "a2693a567aa5551c4ed1a68c81f92521ee8f6401c13e66b709c4fedd1a2bbde4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8f3af10f858b9bb8353adb07fba8d1b9aac710f40cd5fcce5898d2a04140bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0e91a35f71cb26096a673d1d0886c3d5e56d0ddeb021d82c3ba6251ef48dd2f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
