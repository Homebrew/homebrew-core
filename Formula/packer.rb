class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      :tag      => "v1.5.5",
      :revision => "0b7dd740db78245c30ca4fb82477c405bd35e5d3"
  head "https://github.com/hashicorp/packer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80885f9b2105ad75a3b4b90144a89ef02325cba49ff41231e4cbfd8d1c7f37e1" => :catalina
    sha256 "3ae35016b7cf7d553a4841bc81cc90cad52aca170d706e404b0a1dcbe6f3d945" => :mojave
    sha256 "0bf8facca9faa5a5aea6caf4150b5771184ce0e0106f5495d945196c55fec3a5" => :high_sierra
  end

  depends_on "coreutils" => :build
  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    if build.head?
      system "make", "bin"
    else
      system "make", "releasebin"
    end
    bin.install buildpath/"bin/packer"
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
