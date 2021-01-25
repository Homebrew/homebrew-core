class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/v1.5.5.tar.gz"
  sha256 "ec0a0765d768d5f019cf47b1173db84881b5540088cc0e5570fb8140355d3199"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a5502d9e5e76d890ed545c30bc25a69dfcf621cd6fb171d80513b0d7c627609" => :big_sur
    sha256 "c52a5e8fa7d2eacd6827a385f84cdb609357f8cdcb3e0146651a184bfac9b5b9" => :arm64_big_sur
    sha256 "56e6b31b3a255184cbad4ded057ef5990a853a1f75d607f34375f0495e691215" => :catalina
    sha256 "6466e9dd0f2c4f54c09671bc5b463ae0272c3e1d241f46ea5ae265cd8ef4a6a7" => :mojave
    sha256 "5d3c30b0da584861e9a40d291f16feb170f71948c2fa9840d7459b00a3f9ab80" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/miguelmota/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
