class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/howtowhale/dvm"
  url "https://github.com/howtowhale/dvm/archive/0.9.0.tar.gz"
  sha256 "ee54c4aa104cd49aaec3eb65078d9d01d18b1d1eb73a32dba3f7b645df5d74c4"

  bottle do
    cellar :any_skip_relocation
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
