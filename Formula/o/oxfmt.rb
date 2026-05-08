class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.48.0.tgz"
  sha256 "e67063967ab174560d1be7b46b3eaefc2eb9b01e6c06a725c4e37327dccab1a8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78f36ca16e7fa905ea8b67283cea33c68d71c5051a85d2543884fc45c7f36047"
    sha256 cellar: :any,                 arm64_sequoia: "bb91b4330b5d5c2eefaea1ff53ef533cc6176b1cd9131fb271eb7423649340b0"
    sha256 cellar: :any,                 arm64_sonoma:  "bb91b4330b5d5c2eefaea1ff53ef533cc6176b1cd9131fb271eb7423649340b0"
    sha256 cellar: :any,                 sonoma:        "a7cb7fad2ff56469183af5a9164f8652c9e0334b2c4df3a2eb2ed0ed392c2dcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75583650189f7a268739c3f46c14e56a651dc0c81a89e41c5c745c3ec2702a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0a9496320aa9b9ef4af1e7487bc8cae535ee5dbed60bbc32e58ba720c8efeed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"oxfmt", "test.js"
    assert_equal "const arr = [1, 2];\n", (testpath/"test.js").read
  end
end
