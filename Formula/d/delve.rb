class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "c26cce64c4cbef25b7652708cda198e9c081ea3abfbe411ed8048e131dba6275"
  license "MIT"
  head "https://github.com/go-delve/delve.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a13bd7c4078234dded9ffbef666bfcb4e809711c6a01503b923becffe9aa6601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a13bd7c4078234dded9ffbef666bfcb4e809711c6a01503b923becffe9aa6601"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a13bd7c4078234dded9ffbef666bfcb4e809711c6a01503b923becffe9aa6601"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4c37c81f6785a6c4584e4fb038a5d67dff0afd079bc6a49c08564bc212ac76e"
    sha256 cellar: :any_skip_relocation, ventura:       "c4c37c81f6785a6c4584e4fb038a5d67dff0afd079bc6a49c08564bc212ac76e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3516b907362af6a4150146eafe45a30761a5d7c026a9104f6e712d05669fb2c6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dlv"), "./cmd/dlv"

    generate_completions_from_executable(bin/"dlv", "completion")
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
