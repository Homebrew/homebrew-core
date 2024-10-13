class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "9eae425e2629fb8cea2591b87b0a0cb7a8e305bcf3f90c7c121be674d70eca0c"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e1903c3462e0ab8b11d8ccfbdd8f92a5b4a8d15cf04b0017f195d0457c6145fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7b3a38281031987597c841a9273d7abe7bb90aa77733c47aea227b4f48ce79c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "640d5b30d8c6f7966bdb2e676763ee2a30272030d176b89eec85cba14d04470e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f36de3db222fcd87efb330a79adc1b772c50b0e435b20830ce072fecfcb71cdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4650c8e0e71af94890ef525cd6ee2ff735f3db0f702e50f49321976b53b83be"
    sha256 cellar: :any_skip_relocation, ventura:        "10a5839872a1a5351c39e870337f58ccd077ab3c0adbb118fd8b71d3a20dc0f1"
    sha256 cellar: :any_skip_relocation, monterey:       "b28ee6822dfa6457c6c21bccc662ac8cf99b06fa569306c23b1a6b74ade7d267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cec88503ed14ecc8b6555ae57da53f3fc524d05e4ce520c55c9225d78590c0c8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{tap.user}
      -X github.com/arduino/arduino-cli/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"arduino-cli", "completion")
  end

  test do
    system bin/"arduino-cli", "sketch", "new", "test_sketch"
    assert_predicate testpath/"test_sketch/test_sketch.ino", :exist?

    assert_match version.to_s, shell_output("#{bin}/arduino-cli version")
  end
end
