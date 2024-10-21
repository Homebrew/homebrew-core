class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "3486597fc3759779394ab94ba97196b855b039b792008c9b9d9a11a69ad635ad"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5ad7c31003f246b5ebf9082a40cb2c25cbf6d53a9adaff84481757e4f7b7d8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e21c4e1389cbf987277c65d26a25d6f8f87c8bad5662aca28211baebb95948ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c305d81302289cc3930e71bab2008e55516fa63ffc30b2ee03adeffc9a35d354"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf5bafcc9ecd19603d381d643ebcef930fd34a09d0bd2693d5fcee00b5cae539"
    sha256 cellar: :any_skip_relocation, ventura:       "ea4ebefa3db56d95ead4579b89708298254d422576c02e4ecb09e95c090be520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae114b606c2bb038374dfe452f0b929e08941bacd4de337446e44b6c219ccc6a"
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
