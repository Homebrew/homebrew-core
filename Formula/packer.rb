class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      :tag      => "v1.3.3",
      :revision => "508b6efb4ababd3efa3614033f9529a30970899d"
  head "https://github.com/hashicorp/packer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e64d9e9f418f07a310e952edcf7c697a76e189c94f3432404c45d4ef54aff60f" => :mojave
    sha256 "1e73d0a14a5ec13e9ddf28f143828524ee9dd740224355d710be8ecab8e31dac" => :high_sierra
    sha256 "2333c971f8f0cb7ebbf693af8b0d2c3918d65b57e4fb3ac7fc30cc1c19c68755" => :sierra
  end

  depends_on "go" => :build
  depends_on "govendor" => :build
  depends_on "gox" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath

    packerpath = buildpath/"src/github.com/hashicorp/packer"
    packerpath.install Dir["{*,.git}"]

    cd packerpath do
      # Avoid running `go get`
      inreplace "Makefile" do |s|
        s.gsub! "go get github.com/mitchellh/gox", ""
        s.gsub! "go get golang.org/x/tools/cmd/stringer", ""
        s.gsub! "go get github.com/kardianos/govendor", ""
      end

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
