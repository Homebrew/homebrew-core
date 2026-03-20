class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-16.0.0.tgz"
  sha256 "9c771a53d723af8ca4cf173e9adcd0948790a66a7b8e4c3a4113567b333f4793"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b40ed6c5fa6614696778f89addb43d44a23d07bbe7ee7699abbd16b5d5260a33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32d5c0124e929f5b993d92da88eb44999e47f64812b9dc1b3d1eb45d9ff15832"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32d5c0124e929f5b993d92da88eb44999e47f64812b9dc1b3d1eb45d9ff15832"
    sha256 cellar: :any_skip_relocation, sonoma:        "6257f4e2a5ebb3c387981eacfc01a1fe530dbd50f17a2547440fbe84971398f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fa4854114d0298532573e08c9160174698fcc1095887fd78baada6cc0b41ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fa4854114d0298532573e08c9160174698fcc1095887fd78baada6cc0b41ac5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
