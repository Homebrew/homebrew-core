class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "df09593aee5f9e03b4aa4321fca90def01336f11681d87d57e5c73e4574a92cc"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51b5219c8412797db3f85fe4b76b7f798888b196ecb2b77a300e1fa8850bcbf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "387e38355220131a489480a27033753f75f3e5610d0fc21ef1e927b3e104d54f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6aa0feb6773b341ad300530935f7a260f6b6d7813cbebd9da874fd81bd533605"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9ecb96cf5fba04ee9d2703d6e9bf498069a34d15f65383ac3513f70e1f0c25c"
    sha256 cellar: :any_skip_relocation, ventura:       "c49eb0ad4e988fbe9c0168a6f6ae87bb48bcfe704483a5b89c96aa7a0023e4cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14865f8788eb71b03378ff7dc9c6d444f1bbab7b079dc8b770828cabd4daa042"
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
