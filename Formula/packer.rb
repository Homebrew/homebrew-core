class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      :tag      => "v1.4.0",
      :revision => "54d2b32d8c96aeefd6cdc59f4064ef68143fc035"
  head "https://github.com/hashicorp/packer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2906f90eb1ab64a0462a403c0a1b3c7aca87f3e138efeb54360e0c76b1f2085" => :mojave
    sha256 "47b3e62ab3273993f226fb52496295afa5cf4b9f617112d826d5aac671de6561" => :high_sierra
    sha256 "ac790980a58966a1145ddc5feb3bc7325203660a1bb982614b205021540a5e11" => :sierra
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
        s.gsub! "go get golang.org/x/tools/cmd/stringer", ""
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
