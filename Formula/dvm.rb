class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/howtowhale/dvm"
  url "https://github.com/howtowhale/dvm/archive/0.9.1.tar.gz"
  sha256 "e3e3d90ec0b46517b89de8d28fb303733ee764907ffbd61678614da0af2a1567"

  bottle do
    cellar :any_skip_relocation
    sha256 "35e1aaec1421df4159cf0f18d7dbc3deb1620ac84159e05e52cab2b069e69e5b" => :high_sierra
    sha256 "edc8e7c2e5aa099cc14be57247961cb79ef5f677610d0301786cfce41ed55e48" => :sierra
    sha256 "25ea32a37d52751a050f7814205ddc711e5fd1530fc79d4bbe2c987c94152e0c" => :el_capitan
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
