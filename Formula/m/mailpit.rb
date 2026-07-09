class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.30.4.tar.gz"
  sha256 "671f82ddaea0d74fdcb289b1f25ffbf506aebb7de35e596328a24c304a1d3194"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "960a65426b2f21d2b2e68b526438d4462ce4c3f997beee0c79e35a7747ef94e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2563e63ed59b2288a0b93652e56c793ca8d19a7e1de74129e5534ab6a7df1801"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8a7d441c8c61c1d932b6747904965ca1cc91f51bd96fc6cf7d1caf4d4f68e25"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dfd252bf36f62c95339e6bf18e40824e74f9eb6b41791ea8a811f88aca115cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58b267ce84116dd14a8da6001f5e6b35a057e7e6201cb8d66aabc8bc5021349a"
    sha256 cellar: :any,                 x86_64_linux:  "1a4d9e1f7776dd951a26accc6fd4d4db8dc468760c24a09f3b5194897129761c"
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
