class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "59dab9df872adffe0f2b5032d1dce086048551041289c08662280ae5b6407f2f"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7105cc79202b0248984d1741b9709a479eaf7c145324a288bdaffadd12f4c8f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7105cc79202b0248984d1741b9709a479eaf7c145324a288bdaffadd12f4c8f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7105cc79202b0248984d1741b9709a479eaf7c145324a288bdaffadd12f4c8f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "eec8efe3b14eaee61cb9db6292c402135e7100f8539a00b4f17ecf917eac4b6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d77eceb6fa16941e6378524ebce721ee1cebbc0846f65ff313e8434d3eb9aab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39252a23eb162d8e255fbd000a29e56882824fc382064f9324c9925443bca3a0"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"alpine")
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
