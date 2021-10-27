class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer/archive/v1.7.7.tar.gz"
  sha256 "c5684ad323a97cc8b9342a42a590235ad687c8a5f9069a77510491e46e421aba"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "master"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "765632cec479f59ba6a130cedc51c887420ea74603943d51c8567ffe1d46db5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27ee2d8c008ec8570e5dc8c2c7dd5503b668584ac7ba5459491fb4f2cb089cbe"
    sha256 cellar: :any_skip_relocation, monterey:       "41ac762ec6dc18f726d3ae6c624400c93369c1fbaef88a631a92e0b4d7c15668"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9286dbe2930b4a41b982756a4903019b84a2d38924bb47e67baf3455746fcaf"
    sha256 cellar: :any_skip_relocation, catalina:       "7298e01dd64717cc5e6682e952fc7d6b7aa4e77886923a42e346c1c2822d6d63"
    sha256 cellar: :any_skip_relocation, mojave:         "6c6e6f909193b39f292a67fb242f323efe73574de1c3425e58df35525561f788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfae811d28393a2b35c02fee11a19396b608b5060392fe3d5c73d609e6b8f7c9"
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
