class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer/archive/v1.8.6.tar.gz"
  sha256 "11acae341130dff0950a80e4c56df416d547298f42ca49e8e862de23afe1046f"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03609bacb2a233f609b222d7420854d731765b9d2b1f6421a4494a784eecfb00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6381b7c9a374ed22973682f69b736803b37474617e4a576f2e429adabec99fb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c13d0b95c5bb8c21566e25fcdd24229f8e7810909b806d7302704576327d995"
    sha256 cellar: :any_skip_relocation, ventura:        "9ff27fb149d838cc0d05ffee60520f3cbc11cab63832e02f160ee7abe31765de"
    sha256 cellar: :any_skip_relocation, monterey:       "f165f19f592b6028a08ef8ac705e4f0a709fadf6439208eeb079628256e50bf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0337641f64e068e7f180f739b538674c83ffebdc42595b1a90a07b050a22e60d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f200eaffa120eb387dad8eba7db83d077d2de4a468427e0aa9ecb3d8c098c57"
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
