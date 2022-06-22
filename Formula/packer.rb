class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer/archive/v1.8.2.tar.gz"
  sha256 "aa14a0a53d4f06331d556dca6bd6d10dcbbac538061bf5c1a7888311ef5572f0"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a54982fe5bb4c6d5cf543d425389f83fa318776ed236a399e709b20f319cdf98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbf39fb83ad1296979d6a11c9bf167d6316e20a6a49316310a5a0157e75ed3a5"
    sha256 cellar: :any_skip_relocation, monterey:       "f8a0663aacc5eb8c7c0c0ee755ede4de91249c77049cdefce8765c15241fb4b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd9bf699d687d18eaf5ee7210f367395a2609588af7773ad752f1c6f304cbc5d"
    sha256 cellar: :any_skip_relocation, catalina:       "d58410e68c44b6653cbdea1d1d2525b51401489a941dcd79551615bb2324928e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb2e7376f606050ea184dedd2093f9fa64a0eb5a6655531490172e413c173a96"
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
