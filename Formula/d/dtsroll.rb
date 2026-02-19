class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.7.7.tgz"
  sha256 "147a0e03589dd3be2b9798f174f61124957d73dc71070c42edab21711e6ebe8b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47f3981b0d7f70f2445305a67986b75ea81fde027d4faef5c04f8a945fe9654a"
    sha256 cellar: :any,                 arm64_sequoia: "05634a63fd00e82fd7e75cdec3626fab5a6857ec58a4828014441732ce1978cd"
    sha256 cellar: :any,                 arm64_sonoma:  "05634a63fd00e82fd7e75cdec3626fab5a6857ec58a4828014441732ce1978cd"
    sha256 cellar: :any,                 sonoma:        "bda2587383c6e51a6d5360e6798b4b433a0af7afd1f255f57049afa4c02037ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02721bcce456de990f5ed549cea03c6dba9f502e4eec67571010d09a58c57ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f98c875505280eb766c447dd80271fc245ffa877b3da26ecb1306afc554aa5e"
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
