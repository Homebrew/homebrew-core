class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      tag:      "v1.6.1",
      revision: "4c32875c3f8daf1366bf64dd0a8da190ad6f2f06"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c3c872d788b90c1d614a9a9c788274f45b5cf5cf4a6088681558e1dc3f14fe8" => :catalina
    sha256 "230da0bbb296224a712305cfd36b4d4b2f4d8a2022183c21846e67203b62762f" => :mojave
    sha256 "378c692911ac1b286a171af43fd9485ecc4d480b73b981a4d4e85a6a67138ac3" => :high_sierra
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
