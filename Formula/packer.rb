class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      :tag      => "v1.5.6",
      :revision => "c88190a9562be9566efdc5e1cd79f4e82c9396dc"
  head "https://github.com/hashicorp/packer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2e5f5bbfe0bc350e2f5a165d02ceca56e8d5288a0bf5b5f71a0b823ecb94327" => :catalina
    sha256 "8de671da80da8c7a261f485b5c927cf6fcc2031b44a7e72c0c18cfa44f855ae3" => :mojave
    sha256 "5e600a27f5a28fe63765e986895800bd9393dbca5eb2e06d8c0fb05a9379cbf7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    zsh_completion.install "contrib/zsh-completion/_packer"
    prefix.install_metafiles
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
