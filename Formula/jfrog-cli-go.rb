class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.33.2.tar.gz"
  sha256 "b6682085d1ed19448e32bd208227229de43a85bb7e85653bc332c714ffaeb425"

  bottle do
    cellar :any_skip_relocation
    sha256 "25271a36d26303283c11cd62500ca7d444b1890eb0982848eedda9a91ae629a7" => :catalina
    sha256 "66b606d513c2520314b8e55eac2cf231fe727fa523336492c04cd53cc001feff" => :mojave
    sha256 "dfa5eedd9e52effac52cf3b699906d58dca5c2da0610df5871681f8693659836" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "run", "./python/addresources.go"
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
