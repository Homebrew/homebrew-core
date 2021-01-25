class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.43.2.tar.gz"
  sha256 "cf1f4be33be667044b59762e0e8b02c162946a0eb249bc33041411f117e25e38"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd615c6f1f8dc555f9a7f5210016d3a91341c59827ca8ab8b0b6a79e25ee3239" => :big_sur
    sha256 "202ed26a62572b33cd6a5ed28eaa9aa772233ab7021f4ceebdae0894618a951f" => :arm64_big_sur
    sha256 "6d9e39e0dde2a871ac126a4ccff691f7da9068a02f9c4216e954d3fd78047542" => :catalina
    sha256 "4075908cec119cba547d5fd2968a32c33c0107e04a8952161afa5e16b02b8607" => :mojave
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
