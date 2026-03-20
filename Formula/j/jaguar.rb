class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.62.0.tar.gz"
  sha256 "1f044bc9434e54510a92ac60acbf0feae8e347f92403ca687c8cde870434e77f"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ab6a6d615d7eab54dced8ff8682d65ac20bcb48e5cce33d6b91d58aa65fe6a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ab6a6d615d7eab54dced8ff8682d65ac20bcb48e5cce33d6b91d58aa65fe6a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ab6a6d615d7eab54dced8ff8682d65ac20bcb48e5cce33d6b91d58aa65fe6a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c3908b650b756f015ca1570f69aa9a04eca255a9e3db83df9d059ccb49e3a2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7408e6e0a3db08f13cca89d88b2dedfed180a4e7eb12ee8b02d2a8cc6efdc956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "103c2624575a80a66a1cb307a85154e06172c4cd02fd03e5568c05baf5895432"
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
