class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/howtowhale/dvm"
  url "https://github.com/howtowhale/dvm/archive/1.0.1.tar.gz"
  sha256 "417051d48b288130e80217a1951a27bb6ec70ebb9b4d93abbf981e59bde7280c"

  bottle do
    cellar :any_skip_relocation
    sha256 "bebc1646eae582401909cb5f969eab722b9c43009adcf5dc6bb85f3f41cd9a00" => :high_sierra
    sha256 "c04e23b281cef762eec3e3ded17c4b531890a0565670074938f1ffd00abb12de" => :sierra
    sha256 "1f0c433836ebffcb3403fa47725e4f6c2b7f39cb6b445b7fee58cae9720206c3" => :el_capitan
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

  def caveats; <<~EOS
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
