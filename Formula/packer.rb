class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer/archive/v1.7.3.tar.gz"
  sha256 "f08e52321cc5a3ef6651107f8dff29f23cfc6e75f2fdfa87da33d2b5d73e0267"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce7fa76aebf2cd8e73214ef7ac51f262addd7baa037839752b195a2a76f4f90c"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e317dfd6bc295c247f6d31fb6bbb159156709fd1a6c1f7383f01e979e259586"
    sha256 cellar: :any_skip_relocation, catalina:      "840fb5bbc4c541debdf7083d5683f4c46f4ff3025a21055ee0e393a1562046f6"
    sha256 cellar: :any_skip_relocation, mojave:        "da3cfaa2a21c2c94381f7e8c8c6e5bf28b046a62f53dc539dccf9a83518c3842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9062232c9659dc6c5feef4ce187181a23dc86c86cd783bb95dbef51d794886f"
  end

  depends_on "go" => :build

  # Fix for https://github.com/hashicorp/packer/issues/11140
  patch do
    url "https://github.com/hashicorp/packer/commit/0202280167618a95cbd1ec7c57b5ffc1c9f369ba.patch?full_index=1"
    sha256 "48bb26272d44ace70791f94eae8838c3a64c1f2eb9562f24b39b1e042fc61526"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Allow packer to find plugins in Homebrew prefix
    bin.env_script_all_files libexec/"bin", PACKER_PLUGIN_PATH: "$PACKER_PLUGIN_PATH:#{HOMEBREW_PREFIX/"bin"}"

    zsh_completion.install "contrib/zsh-completion/_packer"
  end

  test do
    minimal = testpath/"minimal.json"
    minimal.write <<~EOS
      {
        "builders": [{
          "type": "amazon-ebs",
          "region": "us-east-1",
          "source_ami": "ami-59a4a230",
          "instance_type": "m3.medium",
          "ssh_username": "ubuntu",
          "ami_name": "homebrew packer test  {{timestamp}}"
        }],
        "provisioners": [{
          "type": "shell",
          "inline": [
            "sleep 30",
            "sudo apt-get update"
          ]
        }]
      }
    EOS
    system "#{bin}/packer", "validate", "-syntax-only", minimal
  end
end
