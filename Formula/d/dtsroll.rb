class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.7.1.tgz"
  sha256 "5f96b0803bf9afd76569fb8efe54e34a3bccc3cf5ccd80455b701236347d2acf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "df1d45b90faeb3bfc67e92a45a7cd56e58630f8418959da004efa833209aca2f"
    sha256 cellar: :any,                 arm64_sequoia: "4c8500cfc8519ade9ea530fe47970ee8c9332201d8f3304a50d8419d5ae9a1fb"
    sha256 cellar: :any,                 arm64_sonoma:  "4c8500cfc8519ade9ea530fe47970ee8c9332201d8f3304a50d8419d5ae9a1fb"
    sha256 cellar: :any,                 sonoma:        "a048e57d60ae2d608ac448d63cd301404acf984624259dec94e8ea61cea4c1dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86a7a309b57452e99ca020114b2d35886fbef64ee5011ea16194861de22a1703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f09dfc80a1549eced9298ae0c86698be3f8be67c43ab3475c1841e53dba5d1d6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/dtsroll/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtsroll --version")

    (testpath/"dts.d.ts").write "export type Foo = string;"

    assert_match "Entry points\n → dts.d.ts", shell_output("#{bin}/dtsroll dts.d.ts")
  end
end
