class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/howtowhale/dvm"
  url "https://github.com/howtowhale/dvm/archive/1.0.3.tar.gz"
  sha256 "148c2c48a17435ebcfff17476528522ec39c3f7a5be5866e723c245e0eb21098"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f7ffdde663a096778f5674b405dcf14b063fd9987998b46f25d9f1d48501f47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "810cc709e90853dbf04bad20b47e027b242a7b2e97d7a0ab7d16628371f51e1f"
    sha256 cellar: :any_skip_relocation, monterey:       "c61954e5f72bd6c013abe06b891f4881a89ae146e615c6a4e01b2b671efefd16"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6633823d962ccff3c002e8faab0ccb8b7b91f438ca51b5150eeeaf044db6211"
    sha256 cellar: :any_skip_relocation, catalina:       "129f33fa691fca5b6cdafc4963b69d82fa0c2c8f5373e7d79db653e53af8e24b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a776882a25fc3164629b4ddb7a117870f0f04dd78ef2c8421c0abe08bf7c7752"
  end

  depends_on "go" => :build

  def install
    (buildpath/"src/github.com/howtowhale/dvm").install buildpath.children

    cd "src/github.com/howtowhale/dvm" do
      system "make", "VERSION=#{version}", "UPGRADE_DISABLED=true"
      prefix.install "dvm.sh"
      bash_completion.install "bash_completion" => "dvm"
      (prefix/"dvm-helper").install "dvm-helper/dvm-helper"
    end
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
