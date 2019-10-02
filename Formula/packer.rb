class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      :tag      => "v1.4.4",
      :revision => "17d4e5494784739adad472058b98361a1b7083b6"
  head "https://github.com/hashicorp/packer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e2b93811b4fd1d17de065a84d1f9b1e52a4780b7bc63d893df9c933bc572124" => :catalina
    sha256 "30dbbbc5cc7687aaf7fe5713c1a71552425e33d92e757588f4b13713609d8fe9" => :mojave
    sha256 "af3eb375c67a665c52d7cc33aeeec57ca3795c9cc5dd9ec0e918f8ff15d0ce2e" => :high_sierra
  end

  depends_on "coreutils" => :build
  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = "amd64"
    ENV["GOPATH"] = buildpath

    packerpath = buildpath/"src/github.com/hashicorp/packer"
    packerpath.install Dir["{*,.git}"]

    cd packerpath do
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
