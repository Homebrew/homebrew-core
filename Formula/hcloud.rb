class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.36.0.tar.gz"
  sha256 "d281bff826b626cd1e33ab7a3342988a647941fd02c643cf96da1bd7e2cf3c9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45a315aa3aeb460670361a852d4ed1df2e277b77c538af03c7e37d1cc8334d2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45a315aa3aeb460670361a852d4ed1df2e277b77c538af03c7e37d1cc8334d2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45a315aa3aeb460670361a852d4ed1df2e277b77c538af03c7e37d1cc8334d2e"
    sha256 cellar: :any_skip_relocation, ventura:        "88d067f3eaa27e9a0e8338359e9a6301a79c3369d0d8d77384f91e76d4613302"
    sha256 cellar: :any_skip_relocation, monterey:       "88d067f3eaa27e9a0e8338359e9a6301a79c3369d0d8d77384f91e76d4613302"
    sha256 cellar: :any_skip_relocation, big_sur:        "88d067f3eaa27e9a0e8338359e9a6301a79c3369d0d8d77384f91e76d4613302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bab4d41a18d7fb2eeccae5fca3e13854a40fb541ffc6ddd2dbce31c12209871"
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
