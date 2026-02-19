class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "64eac9899d1d30380955099716a8f5ee24932c6752406ed8c5b5d8add914aba1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53c041af14647ed8c02248832aa492f2f5c69e2ce5c105296e481bf57829248f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6748d75e1c52ad832cae73f78daa4a7a02a3ae6b0eac0102390474680ccd73f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "351bdcebf0026b04d814766aeccf0e2665add09792373aaff7a0896ba8a5ebe2"
    sha256 cellar: :any_skip_relocation, sonoma:        "726259195bf9a8b5002fb546ee2aa9caa009bc74dbf73eddb4af9f19509457d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38b487c7a208b3fe11d02c590169f9e11b8c64dd0715c549ac4de50ecb7bf3cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a931d109dd0b2e7f0213943d7d794eb782363773c1335c13227ce998fe4a2c5"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", shell_parameter_format: :cobra)
  end

  service do
    run opt_bin/"mailpit"
    keep_alive true
    log_path var/"log/mailpit.log"
    error_log_path var/"log/mailpit.log"
  end

  test do
    (testpath/"test_email.txt").write "wrong format message"

    output = shell_output("#{bin}/mailpit sendmail < #{testpath}/test_email.txt 2>&1", 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}/mailpit version")
  end
end
