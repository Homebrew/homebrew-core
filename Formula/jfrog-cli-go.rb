class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.35.1.tar.gz"
  sha256 "e7549c49a270090b66745b17b7f1b4dea941809e8bcac69e4bddb3ed7498b479"

  bottle do
    cellar :any_skip_relocation
    sha256 "98361ad2ca27ae8ea14bc1bbdd7dcf575db415dd2607f2fa517adb85f2bfc961" => :catalina
    sha256 "75e044a3bf59027c086a246ebcac5c2b673b6ab5f4f1ad11f9223ddd9c131d44" => :mojave
    sha256 "f46732693c8d40eb8837678ae1a61d536a5b930b0deb70f606b3f33dfcd29b0e" => :high_sierra
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
