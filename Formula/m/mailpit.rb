class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.21.8.tar.gz"
  sha256 "2e01ffe8dba06c4ca091762251fd4dbe46d8fe303c5385cb91a77c2a46741aa8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb6207b9c8433e3aaa1471dd0be147684e98913c64d4d536fafc7acb1bf596b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d36605c6ddd775e4acbc37a216e3965fdc120b04e3d7fc8d11a55090a35a21fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "669598090baafcec2033dbb26b8da655c58bd1f9629ebb0ad71a4f238723064b"
    sha256 cellar: :any_skip_relocation, sonoma:        "48289cd39a88fad8bcf3f4e0992b3284ad7900948ac91c707075d1fbe3e9a6c9"
    sha256 cellar: :any_skip_relocation, ventura:       "0f61fedf74f488f6f4f888660594ae137407e745fec706cdd702529f4ca831d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "918d2f4ef421d4d4bddf4c74b1d30d871bb21e0bf76d3524bc375bb227db6355"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", "completion")
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
