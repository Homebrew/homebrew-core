class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "1c4f8ef27539e071ce8af437b2a1d046f2e0af34eb2a7aa8016ee201cc55b0bf"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfa9cc7ba8022d4aedfb2f06d055927fb41fc4738a43f6857e067d64448d8583"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfa9cc7ba8022d4aedfb2f06d055927fb41fc4738a43f6857e067d64448d8583"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfa9cc7ba8022d4aedfb2f06d055927fb41fc4738a43f6857e067d64448d8583"
    sha256 cellar: :any_skip_relocation, sonoma:        "c599bda781744313a18a705dbcfe69748c2e0afceb9031a15d5adc75005518c3"
    sha256 cellar: :any_skip_relocation, ventura:       "c599bda781744313a18a705dbcfe69748c2e0afceb9031a15d5adc75005518c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c22023d1893395c2a9e550527e492d7b4cc92000697bdecc6a29495836216524"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "Failed to execute - Failed to create backend", output
  end
end
