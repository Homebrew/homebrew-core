class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/howtowhale/dvm"
  url "https://github.com/howtowhale/dvm/archive/0.9.1.tar.gz"
  sha256 "e3e3d90ec0b46517b89de8d28fb303733ee764907ffbd61678614da0af2a1567"

  bottle do
    cellar :any_skip_relocation
    sha256 "4754b18aaba233a4c8c29c307b2ea24a507d7fb2854e527f35a1091c73e1aa26" => :high_sierra
    sha256 "9ff72c71d4fc692b0b573ab35f7cb834d5322341b03cf36230a2e69734f04422" => :sierra
    sha256 "e1a7194b63b1802e241e2ac8938dd9ecd78b7fa07bc594ae3944a29985816a57" => :el_capitan
    sha256 "b60ca73992ddeca444863ec05ae5ace4d82b9e38f7314027610d809c71a6426a" => :yosemite
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

  def caveats; <<-EOS.undent
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
