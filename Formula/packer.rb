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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af333771d3b8e037efb0a30c42d6f4eec95226356e11d325681f736f17255dab"
    sha256 cellar: :any_skip_relocation, big_sur:       "908d224f7b913c1c68efa613d015fa145a0e98da3ce84d4cbeba7160986138e4"
    sha256 cellar: :any_skip_relocation, catalina:      "886f0a559d6c3858c0c8d463aa482c0a3607d7439fb99fab9023ed7b99a3c7c1"
    sha256 cellar: :any_skip_relocation, mojave:        "ffabebc88441c9a07eaa1d3eda794b86af742931a14fa0601f5389b2c317726f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

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
