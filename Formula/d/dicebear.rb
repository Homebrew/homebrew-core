class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-9.2.1.tgz"
  sha256 "b837106ca2dc746611f0926d8faf57182d06294e7a8450139e34de5bf7bd25f8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "262f266530b8c354b2fdd2c2765a686f3d37e7880b13006f95b52a5ea2e009eb"
    sha256 cellar: :any,                 arm64_ventura:  "262f266530b8c354b2fdd2c2765a686f3d37e7880b13006f95b52a5ea2e009eb"
    sha256 cellar: :any,                 arm64_monterey: "262f266530b8c354b2fdd2c2765a686f3d37e7880b13006f95b52a5ea2e009eb"
    sha256 cellar: :any,                 sonoma:         "84999e26857352a410710a70f4c20a92aae09eab8ff99e92049a22d1d2282c64"
    sha256 cellar: :any,                 ventura:        "84999e26857352a410710a70f4c20a92aae09eab8ff99e92049a22d1d2282c64"
    sha256 cellar: :any,                 monterey:       "84999e26857352a410710a70f4c20a92aae09eab8ff99e92049a22d1d2282c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc7bd6459f4e05438c5bf26579d0cb2179275c7aae5513ba64b1503abef85a16"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/dicebear/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_predicate testpath/"avataaars-0.svg", :exist?

    assert_match version.to_s, shell_output("#{bin}/dicebear --version")
  end
end
