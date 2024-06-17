class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "1053292e031a5d0c9154d32cf01b67d361d0bf953ee7c3374579ce7acc2f1f40"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62f24ffdb4469da643520984fa066c3aaf3a116a1431433e6790b47def62d3eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d1c3b729aeef55435a1aebc881ea34f979b44023b5a030ee9abc3f961e18442"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97c2d885395374fc2881bc0064e27df59219320dc80cab7f45af3e0931245608"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fa8d54b55d176f080c757bc377d716690f5736a441ea4e493adada099eacfbc"
    sha256 cellar: :any_skip_relocation, ventura:        "fa032517d71de1aaed42b850b991515f797308ad73d6cbeb22c61dd1c1167015"
    sha256 cellar: :any_skip_relocation, monterey:       "fbc428bfdcde0b5d3f2678fed30edc17d4ce0295ec1165b56fd24007373d9cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b518885e2f3459bfa8dfe3e6a1b21bcde930e4577ade30a457c74957d584874"
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
