class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer/archive/v1.9.1.tar.gz"
  sha256 "1f3ae38fe9313a072547d1ce5674d74438ad5d59b042a87428534ac39bfd47b7"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6090fec3c10595705ea2dfd6d4021f421cfd993cbf0c1a383d8a6591a46c76bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40eaf19f7f9ce8ee5068ef7feff7ed9a56ad7fc26c95c569eb11c633551674a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b000a0677a6c2f4a6af32a6b47784c49a302df59abeead1a4d1746f00ba2362"
    sha256 cellar: :any_skip_relocation, ventura:        "de2918830615e1ca0510eb77ceea74f739584d8e5f18e8ae70398a7173de3b04"
    sha256 cellar: :any_skip_relocation, monterey:       "ada8220c360cc3756acdf7277394c21bebe3223aef5562a576721ebf8282d5de"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1f529a09e6043113096e852b997e1003a8a7cafc2d2193028e38f650c83ddde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dee0210797709b6f6aeb1836eff01e3ef21c0a956b8686ab47d5832c60f8785"
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
