class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      :tag      => "v1.6.0",
      :revision => "b05ca9e9e1989e832e02b5f676917a5b9c683606"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84918bf57b75d3127afc1aefddeb90eafa5b9f9669cbb87e823a94822ec12aa9" => :catalina
    sha256 "a6bea8c5bbe38a62d40e530b86d46ab747463affe288963adadd9334bf07c810" => :mojave
    sha256 "653dcd30c77a8989039754053efbee6fe901db91866e675b8f0ff8e0d046195e" => :high_sierra
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
