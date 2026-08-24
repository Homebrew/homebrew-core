class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "2c0fb1f771495fbba1a21c41de4c6a26a6be010b0fa04554ca6e757b8d70df36"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75bdede9e1c0b7273206322285e50c5954035455a79fdecdaf94381926db450b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd8f99886281b1f3cb804379ceb43826af044e55b0267bb2f6a1586535a13b16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "347c663c90983098c4a1c629f07d6839c55ab2e29faa99d5a3bbe91a08fa1f55"
    sha256 cellar: :any_skip_relocation, sonoma:        "56034b8ba41274853834d5d000a730d031bff64d5396edbd290e1cf82e8dc540"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88a3a62e92885866f8d57c957515659e9b3e406e2b28a497c422bbc661c0fe6a"
    sha256 cellar: :any,                 x86_64_linux:  "b7ebbb86de9d1335dc2085ffa291de9692c16ee69560bc2b641984a5c463756e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to create backend", output
  end
end
