class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.9.0.tar.gz"
  sha256 "5f549c2c0c36f938b7d38d1fdec1deeb891ea10d534ee0e6a56ee7f9f746e89c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "212ef8fee4b629c635cecdd9d62dd444a96d4e24047f420d6069b0738fc2ab16" => :catalina
    sha256 "52f5d535cefcc43527411992d98de7a80eb923815f249d1e744f62c87b25ce22" => :mojave
    sha256 "fb2169f2abe3585e18aaf7fd375eb3278d5a46b8e76a4092d8674981197f3e4c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "brewgen"
    cd "brew" do
      bin.install "bin/prototool"
      bash_completion.install "etc/bash_completion.d/prototool"
      zsh_completion.install "etc/zsh/site-functions/_prototool"
      man1.install Dir["share/man/man1/*.1"]
      prefix.install_metafiles
    end
  end

  test do
    system bin/"prototool", "config", "init"
    assert_predicate testpath/"prototool.yaml", :exist?
  end
end
