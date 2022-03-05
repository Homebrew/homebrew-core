class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer/archive/v1.8.0.tar.gz"
  sha256 "3df688cb488e746df529474f08a430adf0c7c839c4ed3de2022a094eadc515fd"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "master"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f17dcd55f8fd69fe835752b162f6243771594c147060d2e0816eb4cddd2a293"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "583f04348076c0d4c8cb3f76f2893095f63011e1e92d0aec14d97121ce66397b"
    sha256 cellar: :any_skip_relocation, monterey:       "43c180132579cb560fc264dec8adcb6e10156e9b889385bf62cadc36d5cc179a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b139ee1aa9eec2b296aef7989776c858d4662a3d401b594996d80bcd877d6af"
    sha256 cellar: :any_skip_relocation, catalina:       "e92e0e7206ecd1ba19e91f59b26cfc5815d86bd25e2af9ea470547ed6dfb095f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87e8c49c2f1d1a1bba913f9993e6b61f20595242195ba82b62fc3b2eed533385"
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
