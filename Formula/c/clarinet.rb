class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "de37243c092dc822ab7d747f6b2380a6ec1889456fba4cda06e82095318a06d1"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e72338605a3d491cef1dd225f532c4041dd127930fbb662ceddb08fdc5331a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5ac4417586be622ab1712bedc175654d75589e49d91681f9936a26a5a081b16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66a049119939ce65cb33dd032570c7447c16e014af1030e13db49107cd192b5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac33131380d2ba0c980b3f4106e5ecd5c4c0d0bcd0de0e8289607c2a1c60516b"
    sha256 cellar: :any_skip_relocation, ventura:       "31c1d6edd4d5eeb16c72437344a0dec6d3e7c42d992d8bc9287fe63ecdaece45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26893f188edf415bc6c2b8c6c8cce96b5e642854ceb7c39c2ffae573008d39f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
