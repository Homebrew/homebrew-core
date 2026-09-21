class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "010522b05de0ff6d228beefb272922eb6d4850388d1a76f05b47b41f6e0a31e3"
  license "Apache-2.0"
  head "https://github.com/beringresearch/macpine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)*)$/i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        version = tag[regex, 1]
        next if version.blank?

        # Naively convert tags like `v.01` to `0.1`
        tag.match?(/^v\.?\d+$/i) ? version.chars.join(".") : version
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5723aec635018a78557ce1b3377e72c5f71ec1b3573b04c8062d90f91378808b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5723aec635018a78557ce1b3377e72c5f71ec1b3573b04c8062d90f91378808b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5723aec635018a78557ce1b3377e72c5f71ec1b3573b04c8062d90f91378808b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4de2a02b104ed8d3134936574134b6d06646f3fe3090adcdf4c3c8ad654b74ba"
    sha256 cellar: :any,                 x86_64_linux:      "f70eefb6ca07247f54ee8c4c2bd7f69b50dd0667c2dbe4958fd508e4cf416b58"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"alpine")
    generate_completions_from_executable(bin/"alpine", shell_parameter_format: :cobra)
  end

  service do
    run macos: [opt_bin/"alpine", "start", "+launchctl-autostart"]
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match "NAME STATUS SSH PORTS ARCH PID TAGS \n", shell_output("#{bin}/alpine list")
  end
end
