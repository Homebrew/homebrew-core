class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.66.0.tar.gz"
  sha256 "0ef5e1b0b10feab53143d49e5b79b8a9ab3fc38e87a33c8d2dbd0e08e0059c52"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a4ed0ddcb08ef0077b418cf33fc410a4276a24710236ca4e8e2e15fd154df9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0b4828f1ba25b04c7851d950328d598f2189e4848983c46e7543ae7c6f427ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11a9056a887818b7771a2e35c512c41689ecb4ce97796d7068bf50eefe67a79a"
    sha256 cellar: :any_skip_relocation, sonoma:        "98144acdc7bd12401293b2d2ec536bde0ff2ae184615fdbda7929bc5e88f8dad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f3953b5867b45d6837a60ddddf93d246f5fe00a330784d10a378530f5631869"
    sha256 cellar: :any,                 x86_64_linux:  "fb10a638b1e882a4df4c0ebe7939305c2973bb68afd51b6f82aafce50d7cba7d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hetznercloud/cli/internal/version.version=v#{version}
      -X github.com/hetznercloud/cli/internal/version.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", shell_parameter_format: :cobra)
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
