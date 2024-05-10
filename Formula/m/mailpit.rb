require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "9c44f0d4356d072bb6306b601b57f7ba3ff9b7eab3d4f6b154848ffb5753157f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05b6f6914c6f8bbbc6059b14f3083488fcd52c3a6c6cd8313d5a933041e89cdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3474fc9a0a13f336b326f9e2abf51b30b97cab3a4a6236b1e0a64a378a4e6645"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4589fae19b62dc73becfce375ca04d9f18b3dad11f24fc4ff511e067c1824c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "64475e254448b8551762beef945b9c031b0574cfb199ff7dcbef95006ff76ff1"
    sha256 cellar: :any_skip_relocation, ventura:        "95c182038d662b06e9ae8dfccf5339ddbd1390ae4a0d3983cf1ff6a331e9e810"
    sha256 cellar: :any_skip_relocation, monterey:       "4bbd39c1e8fe382d3718ff0efbedbe146896880d6789dd51e751dc737c66a8af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2af27761891339ff534079ddb30cd297f1397f10d3d06d503058e647364cb72"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
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
