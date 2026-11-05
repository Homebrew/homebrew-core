class Khaos < Formula
  desc "Kafka traffic simulator for observability and chaos engineering"
  homepage "https://github.com/aleksandarskrbic/khaos"
  url "https://github.com/aleksandarskrbic/khaos/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "e300394c907321c0e427da8eb7e80a510a9dc6f94cb86cc1ac1630dda376824f"
  license "Apache-2.0"
  head "https://github.com/aleksandarskrbic/khaos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07f11323be4b199f7ab4a1319208f0ab8fef48e90d46b9c654108782ffb99693"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f94523ade8c0afe24d1dfc52eccf61a8bc88712af8e7e7f9a058fb2ed658b00f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5284f8e70c84cabc67b553c108c08d0c114e238229bd86a9f876ec76a299241c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "159ca52eef00a0e681278a06614586260c86b520ceacbcad85594ead02e19126"
    sha256 cellar: :any,                 x86_64_linux:      "b87868864e9bc82ad8487c9fd9236b704af045c6d82d24c2127bcf9956f4fb1e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/khaos"
    generate_completions_from_executable(bin/"khaos", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Available Scenarios", shell_output("#{bin}/khaos list")
    assert_match version.to_s, shell_output("#{bin}/khaos --version")
  end
end
