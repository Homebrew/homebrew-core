class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "040beffd58ab22ef8d10b4241c2b86347dfc960e27934f6fc6cad002b9747c3a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97402f3464c5d9792989c9ec4e49b1bbc1cc81f1b5ed94051c02f1e1826a413e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1de48268a4d5cf5526c6b83466729b1eb612e96e1cda9c3ae0777848f42a3e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bd4ce3ca1d4bee46e8dfa3ca16b0d3145d2bba20525d9de32114aad42ea15fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a787c7070ad6c25994ce2a94c122e2efe9daae720f4ea36d418896ed31e8237"
    sha256 cellar: :any_skip_relocation, ventura:        "049ea3b0294331f6c9139986e242e73fe063924d24af73c649328e08bc993d72"
    sha256 cellar: :any_skip_relocation, monterey:       "925afc8e32fa3c59b8048bb1a11639611030672dad97d7b0f9e961127ab5538d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e93ea286c5168161917dce8575213380f827a1bf03a9a8f2482af00f43652eaf"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin/"alpine", "completion", base_name: "alpine")
  end

  service do
    run macos: [opt_bin/"alpine", "start", "+launchctl-autostart"]
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match "NAME STATUS SSH PORTS ARCH PID TAGS \n", shell_output("#{bin}/alpine list")
  end
end
