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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e88e6d8e863e5ed50260b8f7507f1ba1a640c4f6e22866c4443bbae7e98a8cb1"
    sha256 cellar: :any_skip_relocation, big_sur:       "174622d9c8704b7c2ae0bcfb9c4a60ea5ad93be19f4a475d5a09bf1497380e73"
    sha256 cellar: :any_skip_relocation, catalina:      "c34469ec8c3131098adff53e3b592eb81873fbd62a1108249101a44715ed0c6d"
    sha256 cellar: :any_skip_relocation, mojave:        "d3d538a52c087d74e4124886f9ccbba3efa4698322d65a1e2c3df79fd8680130"
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
