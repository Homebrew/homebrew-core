class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      tag:      "v1.6.3",
      revision: "49969afd2f3cf2cbf5fbb53c448c767e870df54b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9065b04cb9f3c1f2277f29fc1ce9091db863dbeffd11e199581ec5e7af9a1b11" => :catalina
    sha256 "0f4da45578851b73b22f981f5ddd45b1952f37c59a6ff36f572478ec30a76f74" => :mojave
    sha256 "877c268bc9e608dd5a98124361e159e2c6321669ff24f24140edbe1e0a62db6f" => :high_sierra
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
