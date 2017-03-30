class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/mitchellh/packer.git",
      :tag => "v0.12.3",
      :revision => "c0f2b4768d7f9265adb1aa3c91a0206ca707d91e"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc2fce1dc2b1fad1ffb48be64a5a592f92091cdaf9eb23d25591e28108744e73" => :sierra
    sha256 "78acfb57ec3136f9d6a8e51f35d8ba737b68432496f0347887307799954e7261" => :el_capitan
    sha256 "a7ad3c8b1e29e5dbc0a3e2186a854734857dba886dbce220164e6515d53e1c76" => :yosemite
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/github.com/mitchellh/packer"
    dir.install buildpath.children - [buildpath/".brew_home"]

    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    cd dir do
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      ENV["XC_OS"] = "darwin"
      ENV["XC_ARCH"] = arch
      system "make", "releasebin"

      bin.install buildpath/"bin/packer"
      zsh_completion.install "contrib/zsh-completion/_packer"
      prefix.install_metafiles
    end
  end

  test do
    minimal = testpath/"minimal.json"
    minimal.write <<-EOS.undent
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
    system "#{bin}/packer", "validate", minimal
  end
end
