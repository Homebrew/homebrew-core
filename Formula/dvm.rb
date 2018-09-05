class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/howtowhale/dvm"
  url "https://github.com/howtowhale/dvm/archive/1.0.1.tar.gz"
  sha256 "417051d48b288130e80217a1951a27bb6ec70ebb9b4d93abbf981e59bde7280c"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae193a836bb35d9bb483949c700cd724b604a7f6e4364479b238b368484785aa" => :mojave
    sha256 "18b508c00e7e82028b7a4bea6e739c77130299dd38fb3e4c98a9518429be6457" => :high_sierra
    sha256 "91e37e60f6badef7c4c9e8a81f5fd6f600e3da247b57c1b461c55ff4ecad0ff8" => :sierra
    sha256 "d3e7e6e70d7f1b3bfb6b5e7bc5eca122d353f62f9e468d34f9498ce2fc0d1f44" => :el_capitan
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
