class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.8.0.tgz"
  sha256 "2242d4fbaae3d950943e13a4f9c2ed6530a7eebb9f7c5e90df8905fb970c33e7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1867b9d98857cc28db679cf4eab2a9444121ad0c3e558a3831c469f8703c5263"
    sha256 cellar: :any,                 arm64_sequoia: "d631f83565cca16849e094660c5c0a3152332b9cd7bb2c27ad05ad8fbd3ac0cf"
    sha256 cellar: :any,                 arm64_sonoma:  "d631f83565cca16849e094660c5c0a3152332b9cd7bb2c27ad05ad8fbd3ac0cf"
    sha256 cellar: :any,                 sonoma:        "d9e75ff0d548e5cbbde778e9108121341107bdfa2753e5621b889083b2e6433b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88f1076decbf725959b8d5413c18c20c432fee25bc811d55b0086b228b6b8821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e30a45fbc6d378a35f8b827288c2cda4de617c847d72158b88cd299b4640b08"
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
