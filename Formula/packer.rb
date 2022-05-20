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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5178d82b7487833b7fd5c1321dfe0580c12abaa0d8d9fdfb60c975b7c54a99da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f52ae41581a05c0f7d83b6cd7cfb84bb2af8dabbf0e2eb2661b47cb392ce578c"
    sha256 cellar: :any_skip_relocation, monterey:       "4a2b550d17768d1a00e03bccc8699f544dd29249acd657700d9d7112f5026f05"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb0787c5942f56790806d20d44e55566b4891a4632f1b7632a0cd3c5535aeaef"
    sha256 cellar: :any_skip_relocation, catalina:       "904c3f2176e98f2e84bd61c136be1f5e4f293abd508f2815101e31f0df7f90e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "525896c4b4cfdc0c48d643586ac3118ff5414bc7ec88425c4018fc2664bf027f"
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
