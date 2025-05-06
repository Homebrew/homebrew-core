class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "51ec817e933eb43f5c7524b1faa339d84e8d25b6b52e2b5e4b05f8f82b09d45e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e93c3ad2fff32d4d7010b2d1fda57f8b82abc315ad3254ae6594f26675957ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c6b779505c84d4e020509ba403ae177f2ffaff724fb3063267ec0210489de1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1abb05be29c2bbb93893609746f930cdccceb6cc4750a0bddfe4f0a96e7749dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "49a57dd39d01b3240bcff7b240fe1a07ff27e3c6d95477fc81e371fed2830a22"
    sha256 cellar: :any_skip_relocation, ventura:       "3dbd19039af3a51ef87df80ec743a53b418c77de5c4b64cfa0641aadfe2da763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65e300e8f2fa926f1b69e8fd63c1449444614d7b9ba88a58c50f31959fb40668"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin/"alpine", "completion")
  end

  service do
    run macos: [opt_bin/"alpine", "start", "+launchctl-autostart"]
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match "NAME STATUS SSH PORTS ARCH PID TAGS \n", shell_output("#{bin}/alpine list")
  end
end
