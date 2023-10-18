class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.38.3.tar.gz"
  sha256 "392eb34aaae513867720f3b4bdc09a38d7f51b34d1467910c3aa3a14c5c92fc3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfccf3c2a735f0691bb82db2b86c18537a7ec341a5c63d5f428ac3290462080b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2153c1c0d7f3b993b72eef3315545843d5603724af298fe211a8160b0b0ec47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0721cd902284af7cf9ef80478b10e9f650788644b67c29d9a1744c1cf7496d4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c788c3e4f304422b00b70ab9cec83882f45e2c0ad0ead405ec9698ed9ea26ac"
    sha256 cellar: :any_skip_relocation, ventura:        "9376419034da34d53060b27a828cb0e7810c1cd6c9e36d4170c92419f78ee591"
    sha256 cellar: :any_skip_relocation, monterey:       "e91205d6f36504b69d65cea80f61bf356b4b8d246a3fb995385bd834bf1a040a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c71aac7d5d3c8fe6d42b16614530ce2037a528579b7c5599d64bbf302e5acb7"
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
