class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.8.2.tgz"
  sha256 "a40b1a0cf0fd28f7a2e0dfa69a6234ffd183bf2bb69108851f8a80b6f1d104a4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "407c0964d7920ee3ec5665f6779adb62aab0c6fcdadcba423772f28ca194d1cf"
    sha256 cellar: :any,                 arm64_sequoia: "3d6c5a70f527bc6104be2d36e26d4fa5c8113979ebe32530fb7abe2dc42e5865"
    sha256 cellar: :any,                 arm64_sonoma:  "3d6c5a70f527bc6104be2d36e26d4fa5c8113979ebe32530fb7abe2dc42e5865"
    sha256 cellar: :any,                 sonoma:        "939bb9040536aa58c82fbce9f0afdf4b63145a3fa64733497d14a43de8c54028"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69e31737de19b33a68a8fc465f744f7819a58600d393fbf73e0ab6fafcf91e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc5e2ecc696c8e40ff6120d09f332a1fd0d0e8888ab1b7c4026bd281d891cae5"
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
