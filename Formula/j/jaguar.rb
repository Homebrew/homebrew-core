class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.66.0.tar.gz"
  sha256 "8e8f5460ebf89d244ca92711374c9425a09add692af9744d55d14a9bc37686b7"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e28df261194c4e75af8ec6e2e311209616e41d49c7ad6c1d171652b3f6354300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e28df261194c4e75af8ec6e2e311209616e41d49c7ad6c1d171652b3f6354300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e28df261194c4e75af8ec6e2e311209616e41d49c7ad6c1d171652b3f6354300"
    sha256 cellar: :any_skip_relocation, sonoma:        "c87bb2188d2c2d6dfc9e027e348759b0ff89ccbb49b77f6a016ce71bdc1ed63d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4f341f76323570de8425600a35c370267bbe93ee302715890a71f1730bc141b"
    sha256 cellar: :any,                 x86_64_linux:  "929b668180f7e50c837d796f1e471ef7ef854da21392851e9d3b7e72c1c83f64"
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
