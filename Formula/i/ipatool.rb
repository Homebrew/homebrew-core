class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "7527e6896185c10a8c009124e1d3c62276ebf06915701f90b123afcffd03d480"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0da4cdf6b4fbc9c904b18b613bd4ab33370551c592f61572145c42318a0be893"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36af7d17a62e94943b0bb01fb600fabce35f0b4ba2a8a8744158def9438e441c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fe7c6ecaa326cc5cb34a8e31c3c9e7ea15dfcac499dc8e9d9ffec8336917ed4"
    sha256 cellar: :any_skip_relocation, sonoma:        "79387b5b7e3e7e9d0153a92046ee21b8b6aff7f1d02f933a219bb2a332dfd926"
    sha256 cellar: :any_skip_relocation, ventura:       "378aabe9ed8c78ac4032cebc32186ec050be020c4a5a9f3ca8d8cc0a97d11950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a237bacf6bde652eef91bb9645f27c9f1858277e571943caa0e1930184a402a0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end
