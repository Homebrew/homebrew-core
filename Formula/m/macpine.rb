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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a74b9ab086a73a7fdd82fc84cb28b6ea49f69c11d2eefca958d2d2ce1c791bdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a74b9ab086a73a7fdd82fc84cb28b6ea49f69c11d2eefca958d2d2ce1c791bdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a74b9ab086a73a7fdd82fc84cb28b6ea49f69c11d2eefca958d2d2ce1c791bdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a036b7ce7045b2c361625e77ff2cbca3233da4886bab4987d725803f318e0a7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5bb32e4932c0ea3ee9caf5f8dc4014ece95745a943d43b0027f7405688034ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c6aa501b9744069ad6f0f61e076d9bb69558fc8a160caa26b16e9fcf3d5ae18"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"alpine")
    generate_completions_from_executable(bin/"alpine", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  service do
    run macos: [opt_bin/"alpine", "start", "+launchctl-autostart"]
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match "NAME STATUS SSH PORTS ARCH PID TAGS \n", shell_output("#{bin}/alpine list")
  end
end
