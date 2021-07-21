class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer/archive/v1.7.4.tar.gz"
  sha256 "00a093fa302bde7b1eb01de85474524479126cc91309879f0c33f413918506a5"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c420d6c430d72786c47b6f0c296cabc888e9bdd94a95148f1d1838142ac3011c"
    sha256 cellar: :any_skip_relocation, big_sur:       "85681babd5919e3cb8e7fb6fac274e435ac1fdeb5c4e7a7e68c64eb1559baf2c"
    sha256 cellar: :any_skip_relocation, catalina:      "8a5b93cedd735bbd9fe8d3168b0354acc8fe66be5ae7e52d39e62d411f4c8795"
    sha256 cellar: :any_skip_relocation, mojave:        "17a71d103cd6ed2b6382cbe3b32d3eefda9ff1f8885540f2e77391f595219057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b415033ebc7882ce0a19852c8cdea5b462367d6fcfb0f38c39b7d518a33cb937"
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
