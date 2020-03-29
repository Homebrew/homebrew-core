class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/howtowhale/dvm"
  url "https://github.com/howtowhale/dvm/archive/1.0.2.tar.gz"
  sha256 "eb98d15c92762b36748a6f5fc94c0f795bf993340a4923be0eb907a8c17c6acc"

  bottle do
    cellar :any_skip_relocation
    sha256 "752070abac2550367a3ed11d341a0293de98eaca192d2503ed7166a598d305c9" => :mojave
    sha256 "08e39384ed59d4cbfb38dad2f692589b686bf1bc77e582aaa1889a8e81efb10b" => :high_sierra
    sha256 "c04c4e008a79c5ccb20943ce6da908028b36f8f9973a3c748d1beeec0a64269b" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/howtowhale/dvm").install buildpath.children

    cd "src/github.com/howtowhale/dvm" do
      system "make", "VERSION=#{version}", "UPGRADE_DISABLED=true"
      prefix.install "dvm.sh"
      bash_completion.install "bash_completion" => "dvm"
      (prefix/"dvm-helper").install "dvm-helper/dvm-helper"
      prefix.install_metafiles
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
