class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      :tag => "v1.3.2",
      :revision => "6881d841a1a8374d696d79f156cbc462efe17984"
  head "https://github.com/hashicorp/packer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ef83a301a7d45cea23c11e5def7ecd84fa9de0242ae955f2380af68921fac64" => :mojave
    sha256 "be39aeb515c11d0563848d6103bf1e6aa7e6f923ff6b2661fde8e18a9b19a03f" => :high_sierra
    sha256 "8928c35cb52427ff77749a9b027ea50800bf33ff4c6f5a577731ad719abef225" => :sierra
    sha256 "e2b6911a46ea9fd65a21d22edb9803290f4bcbab65abe5a3d0050f3fabe908a2" => :el_capitan
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
