class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer/archive/v1.7.8.tar.gz"
  sha256 "7f4f3eab48f7e5b153772c079379589d208fd911a155431cf0d7d0f309418af2"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "master"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "142c8b5b4808d2350b01b3116345e96e347e492a05b6682d165c09c26c2b7b84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2a2ab4fb8e90aee4a29834194a3ebcf54ccc2444f80be96d13f98c622670f85"
    sha256 cellar: :any_skip_relocation, monterey:       "36b9e8754b3c79d8a4746cdc545ec2eaf9f699779c96b12a49326c4d9a55567d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec225731830c3e3bdb3e2ec0a4a9d53934e6af1f7b90790f028f1d249ee79f7a"
    sha256 cellar: :any_skip_relocation, catalina:       "063ae76c6a7d9eb1bbc55dea0066eac438230d30201a6947b4274b4e7eea7a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f283572207e1e7cc001b93a0849dafc1154f29772b2087b68ba847d0330ddcd"
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
