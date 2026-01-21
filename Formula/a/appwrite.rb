class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-13.0.1.tgz"
  sha256 "1a0ac75205ad7b06cb6449ad8c54851869ffc0fd2096dcdf72f9acb2fd23b4a0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb260e7639340d5d341f6fe6ed27b52906402cef873de291db3ca2e447bd108f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5f4100a6a642b006499a2f8a5c924ea9ef3f2bee4100b053bb32e31e068b10f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5f4100a6a642b006499a2f8a5c924ea9ef3f2bee4100b053bb32e31e068b10f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c6f72ae93b3b883b9d369b43fc59a8c2b3c6e26fcacf8cb7fdccf85998d8ae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75e621c678e95c48e1fc9c2c77ec4520fc503f3c7c2a482a3efc59df9eaff5bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75e621c678e95c48e1fc9c2c77ec4520fc503f3c7c2a482a3efc59df9eaff5bc"
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
