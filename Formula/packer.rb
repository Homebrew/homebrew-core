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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c82db540f6f65c62c4429147934837a623aeb5ca067fd5c2ffe1c2642054abb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "456f9bf6db1c43567b15430ebe78ec046982f9679569283b0057b907122fee99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "faf5848ca03bda5341a99d203e0f13edea148fe6d80a7cb11cac660c7d30fa61"
    sha256 cellar: :any_skip_relocation, ventura:        "ddde9c8e23145730f223491189763045c53c93e32deaa729e635c303b71f25dd"
    sha256 cellar: :any_skip_relocation, monterey:       "05ebd91932873bbbb37523a13deca11ea2420038304bb012d419bf616dfa018f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e09946055acdda4431fb7a46fad27b51bb92f577708125e980ec4a24b79c630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0d5c387c070a3f1df02943b1c7906afd8cac70ea5565a1a2d25ffc96f40de7c"
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
