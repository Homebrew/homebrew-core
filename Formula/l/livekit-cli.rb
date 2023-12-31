class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "672867db8b0e25c05e4456f28061577f8fe80a2c0201d944d5976b016817ed27"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e17593eaacc8003510b13b89ddf3f3e0619a315f7cb077a8b76ec358874c452f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b24df0637f2e7228692f878b9902fe22af249066d8b98f1ce32979792d30ba2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1049d0a35d43f167305fce36e8732196ef9302a1281fd0384c818e9c4b70cd3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e1dc31847a64d451970bb038eb9039e1b2a0b2dcad11c4c94bb2fd121564e0a"
    sha256 cellar: :any_skip_relocation, ventura:        "7b636505e132823a99b3e65ceef17f85ced7d7f02aeae1c33d63c0a736103fd8"
    sha256 cellar: :any_skip_relocation, monterey:       "0c5f196ad4404a9948dd13344a44f161507e40d6c650e7dc7e4c61fff2c0f44a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43d612059df504b2c588aaaf07f892a46bbd0bfbe7dd43496a6ef7879cc787b8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end
