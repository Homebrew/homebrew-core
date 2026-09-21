class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.68.0.tar.gz"
  sha256 "f514638bf43926ad717c9d9ef82556c4e44b2bc220f87e42c1f0c2bb8b378de7"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "558e11c88e186f4c593cc7f98cd24642b72a752ea3223c5435ec8ced33524cc6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75450aff47678cad63d94b691860b3bc3b89004370147b201d062aefc9177afa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab992aaf9702cb0d426f16e76bd3357b1089753f6b69980182113cf04add34b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "caa610997abbff7390111da380f10a307380582d276515781683fe9c7bb1935a"
    sha256 cellar: :any,                 x86_64_linux:      "6136605bb522d853821b5420e8daa84b222ca697a34b649bbdc108c74d77f858"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
