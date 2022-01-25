class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.11.1.tar.gz"
  sha256 "23cc54bf12b2137b187105cd12150f047ecd3a81db81c2326d6dec691267900f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3eda7f8fdaa59b2ece38fa915113e6b66798aa6d16698a94b66e32c61bd0487b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9cefbdbd9bff0612d86e3d02fb81e803afcbba5d1f6f4abb45b670efb3e3686"
    sha256 cellar: :any_skip_relocation, monterey:       "107e5c7a6632a100f401186a378e10f3763319358ffce5c4c9a4f69daf7ebdea"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f7794283adbe7ef44dd5c82d146fa61f027f0f9a9024f7843b28f3e9e6e7926"
    sha256 cellar: :any_skip_relocation, catalina:       "587e27c99aef487801d4999e1ce64f22de80144cded376227dd7a1f5edaa86fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1e106bf7f34db510efa0197e6adab0ef859044783e5c11ea58d190869a98ae3"
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
