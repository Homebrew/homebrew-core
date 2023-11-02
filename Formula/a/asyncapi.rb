require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.59.1.tgz"
  sha256 "1c1285931dfaf80af959627129804e0b23c6f4dde102c91a655d53d387d84ce3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "76ad91f2d47e01009d95915e987918998a1ccaef0c5d81d6751e6ecac645e99c"
    sha256 cellar: :any,                 arm64_ventura:  "76ad91f2d47e01009d95915e987918998a1ccaef0c5d81d6751e6ecac645e99c"
    sha256 cellar: :any,                 arm64_monterey: "76ad91f2d47e01009d95915e987918998a1ccaef0c5d81d6751e6ecac645e99c"
    sha256 cellar: :any,                 sonoma:         "958759c13053808f4e3bffa6355aa9397021d078cdb8cef98e0b9caf9990db82"
    sha256 cellar: :any,                 ventura:        "958759c13053808f4e3bffa6355aa9397021d078cdb8cef98e0b9caf9990db82"
    sha256 cellar: :any,                 monterey:       "958759c13053808f4e3bffa6355aa9397021d078cdb8cef98e0b9caf9990db82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02558c11cacf49442ef87b8dc5dd5edf09e5b634f20246dc82990ed99fa4cdb0"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
