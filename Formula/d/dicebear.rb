require "language/node"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-7.1.1.tgz"
  sha256 "332285a19b485e45f4a4574f8414b1b19bfae8aa0de15ddbd9be10f6033f4fc9"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "641a664583962bca43e51b5d888313c908706b32d4e0f76eb8a84a302dabc809"
    sha256                               arm64_ventura:  "5ed6aa6dc6b6a6ed92e128ea5a79def22443c1db527f60698208b97ebb3d3a57"
    sha256                               arm64_monterey: "300019cef47f3a76540df445c29358e192a060ddf1be760632292ceb06ae9244"
    sha256                               sonoma:         "5e021532323cdd6c9387e4550ad8f4e60c42f2dd44d34240366d92a406c9edc2"
    sha256                               ventura:        "9638b1ab6f3bd3c7aacfd04286fa7f5efad4d3aa43e7670cde5ab651858e9750"
    sha256                               monterey:       "1c92bad1c69672262ee087910013a7c5f691d6a387cbcf2ce3d9cc70c5d294d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "557094e3a63e342e3e7cf2d4d34f500d38d85952a82e95c639b2e110f0d18b87"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/dicebear/node_modules"
    (node_modules/"@resvg/resvg-js-linux-x64-musl/resvgjs.linux-x64-musl.node").unlink if OS.linux?

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_predicate testpath/"avataaars-0.svg", :exist?

    assert_match version.to_s, shell_output("#{bin}/dicebear --version")
  end
end
