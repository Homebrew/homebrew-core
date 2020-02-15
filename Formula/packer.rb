class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      :tag      => "v1.5.4",
      :revision => "30aa6a0cb45e38638479a9d9c1889e9086b686c4"
  head "https://github.com/hashicorp/packer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "443e8d74d3a9e4558a9827d3eb6027e6e4a4615d93eb9ca95b7eb82aa93f4572" => :catalina
    sha256 "8326b365ec38f175b96cf1adbc6884caee9ea32211aa7b63e499bd1cca1f8a04" => :mojave
    sha256 "4bef092848e59567230d8e7c977dc44b68f8a7b08bfc736425dbbe07083a8338" => :high_sierra
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
