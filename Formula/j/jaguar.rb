class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "52830c096d0431fd7575999b108253cb9a2ce1e74a30b864f165a633b6494bbc"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acd2a4afb712b1a837db32bd9b1d3cc07efe096f25c49cd427875756fbb68ca1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acd2a4afb712b1a837db32bd9b1d3cc07efe096f25c49cd427875756fbb68ca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acd2a4afb712b1a837db32bd9b1d3cc07efe096f25c49cd427875756fbb68ca1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7070d9bf338218ea4a99dd71f81283faa36ae3f3bae0f6c2fbe3e644fc706d78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eec098fb40645d567f3105d2a7ad82c60bb50aa3454df8c4c59e5263ddec1995"
    sha256 cellar: :any,                 x86_64_linux:  "37ba96e3ede21dbc09d35ea299d351152f850900349d559929f668bb409bdd7a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
