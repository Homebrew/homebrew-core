class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.23.0",
      revision: "899dc91b3e2e12948badaffc25eca2cfaefa2eda"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bae8af4aecd07ca5ac57ece0c17387ad7d310d91375daed4c0b178253d44cad8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54e5588c3a2cfd7eeee64da76514f82f45d5505ce7cb47bb41596962cd6bf162"
    sha256 cellar: :any_skip_relocation, monterey:       "2f94dbd7f08288e82b2daa0431c7696219744ca212c52ea962c5d78ca9589390"
    sha256 cellar: :any_skip_relocation, big_sur:        "db675f8f5c2c36b59378d2774535b1bdad46f7ccde87495c4f3b9a3c850cfbf9"
    sha256 cellar: :any_skip_relocation, catalina:       "7a98127797bcb1acc737a47ced6262fd45bd9633de2f2192391536feb58635da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4136941860e46bc8e14f0cdcee1b3133493d81b5796ba819409a32b2d449d530"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{Utils.git_head(length: 8)}
      -X github.com/arduino/arduino-cli/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read(bin/"arduino-cli", "completion", "bash")
    (bash_completion/"arduino-cli").write output

    output = Utils.safe_popen_read(bin/"arduino-cli", "completion", "zsh")
    (zsh_completion/"_arduino-cli").write output

    output = Utils.safe_popen_read(bin/"arduino-cli", "completion", "fish")
    (fish_completion/"arduino-cli.fish").write output
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")

    version_output = shell_output("#{bin}/arduino-cli version 2>&1")
    assert_match("arduino-cli  Version: #{version}", version_output)
    assert_match("Commit:", version_output)
    assert_match(/[a-f0-9]{8}/, version_output)
    assert_match("Date: ", version_output)
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/, version_output)
  end
end
