class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      tag:      "v1.6.5",
      revision: "945908fd74adc3d63687b96caaf55749b44b5625"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "808d8b2dc86b8f5069791c444b2449b94bd546dad553380cc93a777d188baca3" => :catalina
    sha256 "caee624a917d261a067ad3a6213f01a3a1f2e4f4b42ecb2bb1093c869dd249e8" => :mojave
    sha256 "f3d001de7328085e43dfc9c65ac86bf94f98d2241653d020ad84dc5baa07a690" => :high_sierra
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
