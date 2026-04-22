class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.8.1.tgz"
  sha256 "f97a8ff2a9a230e6e57f378e06e7e156b950c38a6ae476fbda0d54a7c6475259"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a6d4621276d79ba33cfc3a0556f923f6fa72fccc3f04fac0d802536f591d002"
    sha256 cellar: :any,                 arm64_sequoia: "9661a9d00258f8506b8e7fd49e1a1d48385a16b88c1de801f9780463651f8c25"
    sha256 cellar: :any,                 arm64_sonoma:  "9661a9d00258f8506b8e7fd49e1a1d48385a16b88c1de801f9780463651f8c25"
    sha256 cellar: :any,                 sonoma:        "59400b69ea3b075a48bbc4df2d44a736186f544a1d99040d5cb796bf098740ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c58068ea2291e15fec6d12c672632357cd5e3fd96d14e1bf2d218c91f11bd55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f520b8c58e216658840dc2468e53748bf0e59f5ce666883576915c918ed58ac"
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
