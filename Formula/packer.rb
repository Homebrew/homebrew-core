class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer/archive/v1.7.4.tar.gz"
  sha256 "00a093fa302bde7b1eb01de85474524479126cc91309879f0c33f413918506a5"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "master"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5857e3b4d569263e92c0215bfbbe0da92396d12573916efb2d8c214afd2c8a14"
    sha256 cellar: :any_skip_relocation, big_sur:       "a3904f2fbc7fa390464436188302479a0612ed9ec80a771542d7c6dc54b797c0"
    sha256 cellar: :any_skip_relocation, catalina:      "b0a55acb7d294f529db1cb83533d837154ac8d3c174d2ca089233a3bf27be06e"
    sha256 cellar: :any_skip_relocation, mojave:        "9bdf0e9d68b8cace130ebd58e88821da155954f575893f2dbe9b97bec7e38562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28427704a6de254be710445deff553349ba3300416758559ecf8e74c065353e1"
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
