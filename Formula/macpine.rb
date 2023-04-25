class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "7015f76d2db5a8645558c946dbb1cdf7a257d1078c4ae5678a35a1bff4cee36c"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82062b8a62560a6f67e219470a71d9b8c691dacac142db8e311395568ff6fd26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18568343b55dcb447a407b243c273a3c164d51660dfa74f815087a760549b4ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0cc0b5a8ecbf2e2838dd7973ff36920baed9c3ed9ad58b14bba1c679852bbe7"
    sha256 cellar: :any_skip_relocation, ventura:        "f56f3e31394cd96580e1ce0958b57a353c840c7395bcb0e111db213a3ae74761"
    sha256 cellar: :any_skip_relocation, monterey:       "7906166750c87a2b1374dbc0bc60bfb8e2e25ac090350beca43ebc70eefec21d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcf0dc7bf0b3854f15270bb7b132287750ad8eb2b8e150369e78d19ff4fac48c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c92bbb2fe8da1bd5a071007fb4f897504aa5afe327c46fd870a4d32b5a91f43a"
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
