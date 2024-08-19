class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.32.tar.gz"
  sha256 "16ce35d5d7bc464c845d23402977f3716c4f271e7319652e5498d3fe8635f0f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9182edfa17a8c9840f36b56f7c8d061dd9621ee531eec907ce4890d8ae93f425"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2d9d7d28e42baede20f4afc84199da3a825e84cecd6462a5496a256532356c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bdf1d02a578f0b51986e526de5e7d8f143833612b41cff1fbd72b75b3e6eb7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ded6627b6b286e582a7edd464bcd75467d1d4ceaa6182c402d4f020ceecd0c5a"
    sha256 cellar: :any_skip_relocation, ventura:        "d37b76ccd338c5d5827e5e78d6311ce9c865df180d123c6ee21ef2aa2c344234"
    sha256 cellar: :any_skip_relocation, monterey:       "f2ec56efc23acde0ea613414b5df398a045d65b80af6c4407cead1853f6f3322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a7a060956577ebc901eec21a116b32f69128a58c0ccda34260ff08b4fec258e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
