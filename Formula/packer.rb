class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      :tag      => "v1.4.2",
      :revision => "deb133452d38a0e3e71851e05a2af23cc2cc062e"
  head "https://github.com/hashicorp/packer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d57229d15208f5e711fa20368a93c1d7cf67d963f03542de4f27cbb2c88d1916" => :mojave
    sha256 "4e998603e188aa2ba421a99d38d9da00581a89896ade34d099b5ae33934e37ef" => :high_sierra
    sha256 "41fecd6ec48dd132f17506477b8d94150188893c9deeab6e21acda763cc4df9a" => :sierra
  end

  depends_on "coreutils" => :build
  depends_on "go" => :build
  depends_on "govendor" => :build
  depends_on "gox" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = "amd64"
    ENV["GOPATH"] = buildpath

    packerpath = buildpath/"src/github.com/hashicorp/packer"
    packerpath.install Dir["{*,.git}"]

    cd packerpath do
      # Avoid running `go get`
      inreplace "Makefile" do |s|
        s.gsub! "go get github.com/mitchellh/gox", ""
        s.gsub! "go get -u github.com/mna/pigeon", ""
        s.gsub! "go get golang.org/x/tools/cmd/goimports", ""
        s.gsub! "go get github.com/alvaroloes/enumer", ""
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
