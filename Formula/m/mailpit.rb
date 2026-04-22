class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.29.7.tar.gz"
  sha256 "23305d5cc49ac793493f5e921bba77f841613effbeb58069ffacc7717b4653e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5a25e6a3c0da033fe6ce9a1e19890db3917d76aac09458563db1e45c055b463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dc21fd26d4cf426476a2c03439df31f2b3e9b0c5544f6df8a11b114553c7c7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4abd483c75b9e608eebe8ce2830dc88ded06daa85108e3590b64a25aeee2441"
    sha256 cellar: :any_skip_relocation, sonoma:        "de13b17d4167cf6518c3f643535e4a75581cd975d716726fb8ed0d1799d6371b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "945fb8903650a85ac536a73f0c002df2dbab33c4819741eb0d9414bbedf5e75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05ad4cba6aab89c35d1fc23b792cee7b6247f3dd006ea52073020171c92ce459"
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
