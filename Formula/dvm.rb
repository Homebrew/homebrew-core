class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/howtowhale/dvm"
  url "https://github.com/howtowhale/dvm/archive/1.0.3.tar.gz"
  sha256 "148c2c48a17435ebcfff17476528522ec39c3f7a5be5866e723c245e0eb21098"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93c9c5d7862ccb6954d87aa1a467cfcde32355801dea1cb09a216488b7ba4e1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a5182fb125b4cb85e293513b2ffa19220070ddaf4a17a1369c709350b7b5332"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0e87324c91248c78c8bdb3fdd8be65a852b12e3df6fc14be1fa972e0e2d24b4"
    sha256 cellar: :any_skip_relocation, ventura:        "6e8fc7a1bc70906f11ce1e4db939b9a5155c1ca4f285cc3a880426e448ada12b"
    sha256 cellar: :any_skip_relocation, monterey:       "784f7bf4ae96b861351f4bd3d51f70b81fe820d0924f1966fa1a73a1b2bbf755"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbf9a8f217c5913219d2495990c893bfd0fd9e6b0e14664899d4f9f21deafafc"
    sha256 cellar: :any_skip_relocation, catalina:       "05b7b3c003c71860b6dfcf4189f1169ac6da67f464c7c7f25ae1230031701acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "675af6c08670c77e16010b4b2a3de3828ffc22dcaa832c5db013b4209cd0617a"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}", "UPGRADE_DISABLED=true"
    prefix.install "dvm.sh"
    bash_completion.install "bash_completion" => "dvm"
    (prefix/"dvm-helper").install "dvm-helper/dvm-helper"
  end

  def caveats
    <<~EOS
      dvm is a shell function, and must be sourced before it can be used.
      Add the following command to your bash profile:
          [ -f #{opt_prefix}/dvm.sh ] && . #{opt_prefix}/dvm.sh
    EOS
  end

  test do
    output = shell_output("bash -c 'source #{prefix}/dvm.sh && dvm --version'")
    assert_match "Docker Version Manager version #{version}", output
  end
end
