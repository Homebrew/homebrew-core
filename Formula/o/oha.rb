class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "970de0952d5a3a75452f0dd6713eaabcb8a34589c4ea6c05cf8ed925c6873ddb"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8448695f1782906047826dcba4ec7e21444c01df3d3d2d40e46e42603e175550"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "056f455813970aca33e82f148d37531653f291f59317d3eb64864313893d553b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "530204a3a3b31c1d80c72ece0464a0394b4912b9fdd14676e6ee2566d3950095"
    sha256 cellar: :any_skip_relocation, sonoma:         "60a4a7eef5701d9d7d50436927a80fc3e7f891eea44e942a82d2a6a05ba12b2f"
    sha256 cellar: :any_skip_relocation, ventura:        "e435f5cf8f85cc0479e181061f9d4ade0e33a64917a3af66cb7e5951e40bba1a"
    sha256 cellar: :any_skip_relocation, monterey:       "99cb561971aa2252366643f32078fd3210f8ed22cc35003b94bdf69f030ca7bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e76ce9d292a3d276ea24d86d44f9f8aab9d0c8af60b16a3c09fa905958ad8856"
  end

  depends_on "cmake" => :build # for aws-lc-sys
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end
