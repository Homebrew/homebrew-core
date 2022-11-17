class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer/archive/v1.8.4.tar.gz"
  sha256 "be86eee1d2cb69f2cfb31217c7eeb8e6482fd9c0e7934d2d2bd02ecfd32ee7b8"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca22d3f885bd1213fa9d9244c4e66a0551c88f8524320503ddcfdb6de8227923"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "636c3132932702801ad70f62bfdab2fe5351f3c412ea7e9a7e97c19a9a836e26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d99b9a188c04bbaf6b592f002f855e50b751116881057c516728ede046712c7"
    sha256 cellar: :any_skip_relocation, ventura:        "8e696564d39907817b8fa324b10a5498cb83e30c0c12e2fa9b2ab2a40abe0d4d"
    sha256 cellar: :any_skip_relocation, monterey:       "016ae4e4844c3b10962f34529ba4cacc95e72c668382d20c4598015318bde038"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d08481dfceda0da3b38113078ac3745b9766addc9e0ed5c6baa832eb11cc099"
    sha256 cellar: :any_skip_relocation, catalina:       "5757a7351d51f551392bc6c1b117e63f4090ff5e07ddab4e535f22a32632382b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b828c94ce99814ee88c29fef1ff6c3d2a2a29a3dc41902dd4ef710aef9a26fa"
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
