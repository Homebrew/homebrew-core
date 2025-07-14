class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "5113cee9128c64cecfe6fa6896e8373a30d14c7f2bcb3614a575fbd024bb5681"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e69f79679330be182ebf77132894e788f200c651f861b7f7ec6f4d4b116b4643"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e69f79679330be182ebf77132894e788f200c651f861b7f7ec6f4d4b116b4643"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e69f79679330be182ebf77132894e788f200c651f861b7f7ec6f4d4b116b4643"
    sha256 cellar: :any_skip_relocation, sonoma:        "e016507acd858b8d9d67a2d8aa714e55d68fbe1ef957bc2b5d2fff9cbea9c4d1"
    sha256 cellar: :any_skip_relocation, ventura:       "e016507acd858b8d9d67a2d8aa714e55d68fbe1ef957bc2b5d2fff9cbea9c4d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aea9ee77fee06d17f55f058b3889689043a952c598e2c6bf74fca55f2fe71595"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jag"), "./cmd/jag"

    generate_completions_from_executable(bin/"jag", "completion")
  end

  test do
    assert_match "Version:\t v#{version}", shell_output(bin/"jag --no-analytics version 2>&1")

    (testpath/"hello.toit").write <<~TOIT
      main:
        print "Hello, world!"
    TOIT

    # Cannot do anything without installing SDK to $HOME/.cache/jaguar/
    assert_match "You must setup the SDK", shell_output(bin/"jag run #{testpath}/hello.toit 2>&1", 1)
  end
end
