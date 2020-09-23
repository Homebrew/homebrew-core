class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.39.5.tar.gz"
  sha256 "75a0f9bfd3170d03c542b62442761822ff2e4a7a279406d9b2ee5eeee888813f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "013854114968b28fe9bcb82475b59c4ff5e3f4644154188748533024761f9d63" => :catalina
    sha256 "ac1b37d0e59757f866fdd3b8ce4ea559400a5a5fd8a8b335fbe69cf3301bbea8" => :mojave
    sha256 "517b062a251bfe00183daeacee3a5a69efd7e4215a473d0c9babf01226cbca7a" => :high_sierra
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
