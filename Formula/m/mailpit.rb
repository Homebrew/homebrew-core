class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.29.4.tar.gz"
  sha256 "cb96d3fb917d07820dba3fe984c0df397313d18e78f9f1ed88541f1748c8a5e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4639592204d02e6e5c05b2ee0d659832fccf53696a6ea9776304ec9bc7466082"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "288c50adcd66f090e8d79456a3cd0b826fa9e1a79c1e9113d8db27936cf9f8c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "462dd4cb3f8ea0809b88aaa3db4ef735cf5159cf3a945453e7ba9f54e0f76aa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6296ae1c68fe87e0beec5643e3db2433459bc7e39012dfc9b751a0fbfc90e77d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ea092c22df7bcf363ac5249f5bb02387f3eb0db93fb7b49e0cbc903dd0789d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51193cf478eb1bac853a76928e2b116f64fc090cd9b70364e3486f02c2dc6845"
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
