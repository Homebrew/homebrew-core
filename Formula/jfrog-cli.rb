class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.38.4.tar.gz"
  sha256 "1b321e186c3a745fce039deb8cbd9ea38e27b9f01972cf3a153b601597c60854"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d4296723a05a4b6c569b0d509c1eee76a57ca725039c077657ff10745f72b64" => :catalina
    sha256 "06facd617d87a615d7442d40419326f183ef47f3348eb283134df744f5003b0e" => :mojave
    sha256 "abc6da254c7cb7ae9d95b64f43438b88654c4f3e9ff7271a6f498f526900c1cf" => :high_sierra
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
