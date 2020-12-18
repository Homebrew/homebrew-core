class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.42.2.tar.gz"
  sha256 "f2c6efbe8f91f8dd5a5cff566a3143045ca421854b7aa5f1f81689924c2528e1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6503972bfa3b60cd5cbb08df037cee555c6fe9a0e9aae3a0c9f1c38f826abe20" => :big_sur
    sha256 "9214a92ed4ed40122a6da0925b4ece3e00664a66d310acc04e5e90222a85dad5" => :catalina
    sha256 "85704ce17f221f84553e8fe8d66ec20a6ac65b639491a4e3ad58508b0f6b562d" => :mojave
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
