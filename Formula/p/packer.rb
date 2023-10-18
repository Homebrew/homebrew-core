class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  # NOTE: Do not bump to 1.10.0 as license changed to BUSL-1.1
  # https://github.com/hashicorp/packer/pull/12568
  # https://github.com/hashicorp/packer/pull/12575
  url "https://github.com/hashicorp/packer/archive/v1.9.4.tar.gz"
  sha256 "c07db8375190668571077784f4a650514d6ef879ae45cb4c3c1717ad8308c47e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a88ef4032fc80f0347ece6d35b91a41ebed9aed3ed04af63d1dd03e809d324aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e14a06bebe83306fa56aade8483619adaf96fd85fb1a00ee7b6369b55b631995"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05ab86d40ff440b8ccc078834079db25b5c1b68503e43cd6a04770dd73a6630c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e645398c3ce8a27db807c07d120d260a659edf07fd3a922820a7d14c6a0d1da3"
    sha256 cellar: :any_skip_relocation, sonoma:         "58511c7a5f98921bbd6eb7ec41547ad2d1e5d2e6cb62c2ea5dbcbdc4f64c46d1"
    sha256 cellar: :any_skip_relocation, ventura:        "3a0ca5788a1c761f798a042d914b62249f29e40c360192531eb6e2ba4701773f"
    sha256 cellar: :any_skip_relocation, monterey:       "5c93d433afad1eda9266a8306f0af89821bd514936acff2110457e3c2fa1c39d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0300b120685c80a97e1d4059e9fca8005dfeb45313d5499935bd782bb592288c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd24e327731cd263982ff7b0b47e6c9d4ac253c7b3da82ad79d15f182abed659"
  end

  # https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
  deprecate! date: "2023-09-27", because: "will change its license to BUSL on the next release"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Allow packer to find plugins in Homebrew prefix
    bin.env_script_all_files libexec/"bin", PACKER_PLUGIN_PATH: "$PACKER_PLUGIN_PATH:#{HOMEBREW_PREFIX/"bin"}"

    zsh_completion.install "contrib/zsh-completion/_packer"
  end

  def caveats
    <<~EOS
      We will not accept any new packer releases in homebrew/core (with the BUSL license).
      The next release will change to a non-open-source license:
      https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
      See our documentation for acceptable licences:
        https://docs.brew.sh/License-Guidelines
    EOS
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
