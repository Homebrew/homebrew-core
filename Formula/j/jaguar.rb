class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.68.0.tar.gz"
  sha256 "4e897f0de86ede6a2aff7957e0bc66ecc61f9e8e4045fed225fdaa79306c6c02"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfffbac101813ca2a5b9438cc9df228b34f32347d76732d618a8878a136d6fef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfffbac101813ca2a5b9438cc9df228b34f32347d76732d618a8878a136d6fef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfffbac101813ca2a5b9438cc9df228b34f32347d76732d618a8878a136d6fef"
    sha256 cellar: :any_skip_relocation, sonoma:        "2087d246df43425de4e282465760af18f0f96194cb26a1b1ef182448882a755f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1f4b893e5e26a12c7476c297ba3a0fc80632baf9075f516affa9d53531728df"
    sha256 cellar: :any,                 x86_64_linux:  "10104ea7cee6f51513c5772cff549c05d26ee043ebc0e2f47d257af22f76473c"
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
