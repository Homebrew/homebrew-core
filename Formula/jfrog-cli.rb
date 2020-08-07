class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/1.38.3.tar.gz"
  sha256 "c62ce84d230c7855ab7321b18c3266ccb44f44255ff811513df880342879c786"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0f1fe16927b98e52471328ead28971d2492395dcee462fd5d18acee896d0f37" => :catalina
    sha256 "4dda90a876d29f9871d0f7b1b09dee1043e9542ecbebc73eb3a301fcc2279012" => :mojave
    sha256 "1c84763c61b89ad0ebc1f5005da32e8fb43091d6f6653d82d6193828deff97e2" => :high_sierra
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
