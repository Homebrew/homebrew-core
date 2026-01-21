class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.60.0.tar.gz"
  sha256 "24b3ff0bbd5e9cd50776a8f3b9eca5491c60e42786d4a5e6a377db866d5d9ab2"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33af8d0d9a2d6aca86254da52170e63493b2e097e4506f1d4a089b3c54d3d2f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9cfd49a278b53d0bd5f7efbc6e06e185f2c528944777d66fcbb6597545634db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "387cd22f092f10b897c894e75b60794af18c1896ef6f42ab4d1fe132bce785c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "aff9b34ebbac67509f80d6395f5f29dd4e64e29199d98119a8527cdd00aa4866"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe0ae9077477cbd9a9fb244fd45310381d30ec35792f0f9b127685c80658618f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81c45e463ad0c5e03b2afaa17a458a83549569a899cdedc872622179b088cc3b"
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
