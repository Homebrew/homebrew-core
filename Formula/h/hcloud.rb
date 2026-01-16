class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.59.0.tar.gz"
  sha256 "3b4b1d872c72a3da31204f743cf442cc4c5c84993f651d178d5bce0f0a7d0293"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3edd4f84988d4f16eeabcc916bcc03f84c740846d751037f0dc0f667ae1575e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "366cf0fd8bca1bad9fa653d822a4478b6d3cf6cfe5ab63c0ae71cc7d452dd497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b4e23b8fabd79c550c7f92efb47d7f94721a433630cd87c6c7b31d0c9e86e8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "57c5e0bba57ad7e4a3eee85f74127e7fd451a254e47f2d8bbdefc58a85868d0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a8b42ebda51fa798ffd9457fe3473b080b61c2e2ce62534251b64a8cd987186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "637dedf40f8132fa4053cbc01143d0c50c94bf2017666128311ce6e93e018148"
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
