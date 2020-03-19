class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.35.0.tar.gz"
  sha256 "d45727279a61f7074892311e01b683022b155f8b6100e054566dfac59936d8a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "b634319952b1969415ab9fadebf58109ebd30ec875ff72a81daa697a10011cc4" => :catalina
    sha256 "f99c0492c0c3f7cb840340eb306d27d5aef157efe3aad00f3e4633f762043b80" => :mojave
    sha256 "9748de88228335f2cb30e25be6cc5542cf64994509f6ba40e0772e33d227ba07" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -extldflags '-static'", "-trimpath", "-o", bin/"jfrog"
    prefix.install_metafiles
    system "go", "generate", "./completion/shells/..."
    bash_completion.install "completion/shells/bash/jfrog"
    zsh_completion.install "completion/shells/zsh/jfrog" => "_jfrog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
