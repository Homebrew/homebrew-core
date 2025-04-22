class Bender < Formula
  desc "Dependency management tool for hardware projects"
  homepage "https://github.com/pulp-platform/bender"
  url "https://github.com/pulp-platform/bender/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "1de599efd238f3238e9bed09005547e63b82c4d98affcd63c565ab650bebc9ad"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/pulp-platform/bender.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0025f80ceab8991afc8be4e8beb1987fde448db3ff24c614063a73552cb38d36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a620fe1ab9b5780e8c40141af6565232f050679f16437cd38a3792a4e63809bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b8aa18cb5cc4618a4a902a66344a7a5e6db58420892a74cef95db97b62eb896"
    sha256 cellar: :any_skip_relocation, sonoma:        "278268ed63d2c0c7becc6062fb2d85af2e5f906ce83999ee064c37c7a6b6553b"
    sha256 cellar: :any_skip_relocation, ventura:       "47002f217ee6c2ab0b3443193cbc376eba93da8d8871a7b8ca616f8f04cdf2cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "716652ec6f1abd66d61826ecfb6032a1a1bf385928a1011934f71acea34dd09c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbf6968800c089378274ab4ac70a4f709b2b7fa688d601cbcfc17538d01e9fbe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bender --version")

    system bin/"bender", "init"
    assert_match "manifest format `Bender.yml`", (testpath/"Bender.yml").read
  end
end
