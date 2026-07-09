class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-4.0.0.tgz"
  sha256 "6dd5c853c1a62e72d6101741a498b3b9fe4db21e68ec2e024541b488b858c77f"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_tahoe:   "7cbe4b189cebb2bb9600e19880221987abdae68071e39baee6dd9b7a5c8d1000"
    sha256                               arm64_sequoia: "3a775fa6fad091d1c382d58c49d484e416261ce2073c36ed6271364a34fc4821"
    sha256                               arm64_sonoma:  "9002e01f762eb91b75a41e88d537b00610cbfa942f2fa84c2bc157882cefa551"
    sha256                               arm64_ventura: "374ccb0c275550317f8b579c6e663eaa8ae22a498c83f94cb33f5ca06d3b7640"
    sha256                               sonoma:        "ff54487e87007c2255d2821735ef79a48e2110eabcced192b53efc067339eb63"
    sha256                               ventura:       "1c13fb4091005e6408f8db2b02e2a56d69a1833d4b1dc3d4e9d9b50ea8676c5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efe0fab8f5576b66ad2b6ced19f7c5e545a8d5c1a8d34c36e917facbf18ef240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a682cf65cd7e19afb1a0c8af45d3d76325376311433592478c2412e091ba7cfd"
  end

  # Fauna Service Winding Down, https://news.ycombinator.com/item?id=43414742
  deprecate! date: "2025-06-22", because: :unmaintained
  disable! date: "2026-06-22", because: :unmaintained

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    libexec.glob("lib/node_modules/fauna-shell/dist/{*.node,fauna}")
           .each { |f| rm(f) }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fauna --version")

    output = shell_output("#{bin}/fauna local --name local-fauna 2>&1", 1)
    assert_match "[StartContainer] Docker service is not available", output
  end
end
