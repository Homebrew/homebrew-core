class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer/archive/v1.7.5.tar.gz"
  sha256 "9a8926eec2ec04d1fc51a3ef8b4952cec95af85fd1b661b3544730aa8a77cd6a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "master"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b09949621386b563bc32d274b44c47aedbd703aafb822114576320c2bd234fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "df3cd01ed90c99e55ac344551debba192bf8dfba13e82858f206ef8dd4c5a842"
    sha256 cellar: :any_skip_relocation, catalina:      "12d549b344f2188dafee6bb07a636d931ad16621965615fc8037bc99684a1a8c"
    sha256 cellar: :any_skip_relocation, mojave:        "6baf45e45b57ebca3ba2019354ba9797e638429f43ce5cc4c0d25430f27ab6f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a76dbbcee33cd30a1a93cddb9b6becfeee463c0e302d882dd4b43ce269f02026"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Allow packer to find plugins in Homebrew prefix
    bin.env_script_all_files libexec/"bin", PACKER_PLUGIN_PATH: "$PACKER_PLUGIN_PATH:#{HOMEBREW_PREFIX/"bin"}"

    zsh_completion.install "contrib/zsh-completion/_packer"
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
