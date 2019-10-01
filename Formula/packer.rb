class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      :tag      => "v1.4.4",
      :revision => "17d4e5494784739adad472058b98361a1b7083b6"
  head "https://github.com/hashicorp/packer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "809870fa11060b2cc68e054022ce6a386bb4c149192da7f1b200d9de76495dd1" => :mojave
    sha256 "c024a681b73e730e7c8f1803916d6c49aee118f4229f35e77a2219dde0c7c81d" => :high_sierra
    sha256 "100a4a7e772119db8624f06db30659e2ace88981e68307f1b9a82473c6913c3b" => :sierra
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
