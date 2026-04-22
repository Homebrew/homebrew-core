class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.63.0.tar.gz"
  sha256 "874258f7a6aaa9b683b5bc34149bf0d91d530f50edcab4be8c05f098784a663a"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b14ff5cd528cc5503cc4bd218c81cff2df25cb066f6b5803c632fa99099f0220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b14ff5cd528cc5503cc4bd218c81cff2df25cb066f6b5803c632fa99099f0220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b14ff5cd528cc5503cc4bd218c81cff2df25cb066f6b5803c632fa99099f0220"
    sha256 cellar: :any_skip_relocation, sonoma:        "6989e68634845456f400026ba8a02d3fa3e62c6daefd28a95d78fe3a22b9dc9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e77c590092db6367ca86fe50f175a8dfd2c50bee9f032da260964ff554a307d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e347c8ef79d9716fe685091b395d8136082777d186eddeb9542d01463384997"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jag"), "./cmd/jag"

    generate_completions_from_executable(bin/"jag", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:\t v#{version}", shell_output("#{bin}/jag --no-analytics version 2>&1")

    (testpath/"hello.toit").write <<~TOIT
      main:
        print "Hello, world!"
    TOIT

    # Cannot do anything without installing SDK to $HOME/.cache/jaguar/
    assert_match "You must setup the SDK", shell_output("#{bin}/jag run #{testpath}/hello.toit 2>&1", 1)
  end
end
