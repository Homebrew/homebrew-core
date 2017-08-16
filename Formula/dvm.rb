class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/howtowhale/dvm"
  url "https://github.com/howtowhale/dvm/archive/0.9.0.tar.gz"
  sha256 "ee54c4aa104cd49aaec3eb65078d9d01d18b1d1eb73a32dba3f7b645df5d74c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "db18f0bef6906ec06abc83d760a3a260f1457c5aadee7bf064c9b6adef16e5c2" => :sierra
    sha256 "28d0fe4c0c01241bbdbd074480648f232fad3818bd929ae900a917ffbf9af493" => :el_capitan
    sha256 "f0d0822caae95580d42407bb5b286ca9d5ebce3ea87e9e9f6a1dc377291bb86c" => :yosemite
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
