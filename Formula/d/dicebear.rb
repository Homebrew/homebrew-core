class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-9.2.2.tgz"
  sha256 "ac1d4abf73dce99db7535b2ccf43a8d55a4219ffa526b96db31809e77fe4aa23"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5046d62bd429c224479312085090e5ffff58d13afc0296e39862a45478261a12"
    sha256 cellar: :any,                 arm64_sonoma:  "5046d62bd429c224479312085090e5ffff58d13afc0296e39862a45478261a12"
    sha256 cellar: :any,                 arm64_ventura: "5046d62bd429c224479312085090e5ffff58d13afc0296e39862a45478261a12"
    sha256                               sonoma:        "51873d0358db2c72a4d0750e0d385b91f4956acf2bad9e6b5a53b46c695f5db2"
    sha256                               ventura:       "51873d0358db2c72a4d0750e0d385b91f4956acf2bad9e6b5a53b46c695f5db2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d49ce11619a7c5457a090a4b0c2a5f3c34ff7e2e36b7eac733c02b9c50f70d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8e5304c29b9f49af28a870360fc2964e32b884a2c59ebbd66ab028bda584ff7"
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
    assert_path_exists testpath/"avataaars-0.svg"

    assert_match version.to_s, shell_output("#{bin}/dicebear --version")
  end
end
