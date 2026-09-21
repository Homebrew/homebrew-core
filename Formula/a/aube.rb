class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v2.2.17.tar.gz"
  sha256 "31d8149768ecf88ed256384664b74e6e7bf464c09c938ba4382cf1178c131060"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8072b9db41634cf0909ad14881af8110e5e3b7622983668290c7b8944cedbc5c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb48ca65ae134f159e85d3bf676e2c1a1c90df797ae058a5a8ffcfe29f1b65f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10b7d0b8460591f5faba8d2a36ac336ebd147a8f3504b3a23fc9a8b51301c0af"
    sha256 cellar: :any,                 arm64_linux:       "5137b51efcdf629a5ae7be551c5ff847443ab422e03fba790c571ee6b296521d"
    sha256 cellar: :any,                 x86_64_linux:      "d406b6bf5bd3afa518a10b8b2dedeb583875c0e12cee03fe7d2a86811e70636f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end
