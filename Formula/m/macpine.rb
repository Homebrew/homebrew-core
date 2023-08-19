class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "96cdb060bc6985cce3e9d985cdf85ce61fc9139776da9b25b8daf042e492e5b9"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27ac2c43820daee2a450370ada921e41e5c0e89cf1898db3143cae08f90f5a92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c9767f32fafb9a243222e103a7c7d6eb426cfa484d23d8cba6e2d043a4e518c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ce63299663e73cd5ba19cb34e2d4fb8081e811ff48850e6e99cccd9f1c7898e"
    sha256 cellar: :any_skip_relocation, ventura:        "f4fe128c08668a405def079af6900dcf52e522cd5632cefd70f9065275e30635"
    sha256 cellar: :any_skip_relocation, monterey:       "741d7b0bc6325694f894d1594e37258b1d40b567bcdbd8d8e784411ebc617904"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3945ae2fb4f9499f3fbd063397723111d983769949754ea074c960660d8c902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e037b0dd335a188fe107183d820c0498543f359106290ba3b63f27c233fc3578"
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
