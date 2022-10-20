class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer/archive/v1.8.3.tar.gz"
  sha256 "763b4c759c5113885189f484c648d19b2b2f141d3d654e9cd3125c290b188462"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6450672f64004579ab0b804eb67caacb6b437465ec6fc62cff3c48ce5d7cf5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36dada898dab46100ddd0efdae0d931661e393a04cb205c9be6edbe426ebd9e0"
    sha256 cellar: :any_skip_relocation, monterey:       "747daa892415e5931f4aea11de0f4f1ec0f5f795320a88f77d9576c44ccfae32"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7d83a2d07aa2c449caab6da7716bde7ab59f630c1067b45b313a2c8b254a0a2"
    sha256 cellar: :any_skip_relocation, catalina:       "ab3fff869e28816d9d9ded02c82d6f5da1810306bb403ee63a70aca8f42a2e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd00ac0214d851b7c09131326d6f2a4a193b3ef39624f56cff5c4f451e75a17"
  end

  depends_on "go" => :build

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
