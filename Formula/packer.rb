class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      :tag      => "v1.5.2",
      :revision => "768e0921b83b272b2f0c93f69780266bb1812dd4"
  head "https://github.com/hashicorp/packer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b677568879c147832d4b3257ceb8c2be85b9734dd8d32f023ac555c5033b9184" => :catalina
    sha256 "3c31fa5d294cea8b70fff1509e99622a445459fade8af68a2e22af6bb324b2bf" => :mojave
    sha256 "98c5d43324077d4aff6ed91e5ee2f2587d15ea81db625856e1d5862f693eb980" => :high_sierra
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
