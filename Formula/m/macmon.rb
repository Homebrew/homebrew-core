class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "02613f795e6c423eb6e234ff91d1f6e8bcb3e2012637051b4729dc4d5f629429"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a95b91a0528a82bb18f6f0d0758c762cb1f1e9c3a19fa265b10951a76bf5e39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7a477665e5ef3380bbd05d98b87d13a101fd216536338da01df4b10fdd9a8c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "163038b5bbc58daca757e292eb9cffc5b1bfd5c2e666143ced73c03de69953af"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmon --version")
    assert_match "Failed to get channels", shell_output("#{bin}/macmon debug 2>&1", 1)
  end
end
