class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.32.0.tar.gz"
  sha256 "4354a81f6a6227cf4b2ffba09e769a4898c572d2b85a579a77b7a09506345a86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc2b1aa458056bc26b179cb3f507519f43e85b69c29fa742c5849de293980508"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07370138e5435a09a6a45cb681d5a20447e5b616316f8a4765488995a1a683c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c99816aaa8b3bb2a4690e654b8e64079b2f3193d3fcc9c7f2f2ec4c74edd1348"
    sha256 cellar: :any_skip_relocation, ventura:        "6e92d2575604e7b8ede752f4820a5692e54b97e7d62e88fbda9fee32acd4d2fb"
    sha256 cellar: :any_skip_relocation, monterey:       "4da94e9d4edf7b5b6cf78d7c9bb193ef928ae920eecb0f9911596548fef20b3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "41af47c9690f373990f708dfce797a7675076b9ab3af5e1d9dfc3a03cd83e76f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfa1e981fcdd655b2af1856837831d8ec4b733695e1c6e3855899b5c575a4235"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", "completion")
  end

  test do
    config_path = testpath/".config/hcloud/cli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}/hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}/hcloud context list")
    assert_match "test", shell_output("#{bin}/hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}/hcloud version")
  end
end
