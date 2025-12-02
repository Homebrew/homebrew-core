class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.8.0",
      revision: "406c7dc8d6bc3f8687d653e9440092ca6ddf767a"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee5dc3cbfb9dc4f6aeabc48cd24c409a4cffdf40214a1a1dadb5156cfa01d6dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61ed7547b8fabaf98f3bbe6ead97b55ed0a2deec76dd351f127991fed7bbc17d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57733c2392c8bc80d25c6abdb833acaa4533af364d4963873be10a9bfd015024"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b88234cbd7b21868771ba3fef32e5e4cc242f0b013058429b19b6c335647dabb"
    sha256 cellar: :any_skip_relocation, sonoma:        "89215db2a9bea5178e8d7bee42cad3b557059d140784abfdd3057c9a897fafff"
    sha256 cellar: :any_skip_relocation, ventura:       "73dfd5ddd4e3b8737909f75b4f6bada8f6a6091f05f9439a7f67fad4d58c3218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b353deded13d375f2371ed2502374b0d8988d6cc7fbfe27bca42739f835c260e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dac75f68bbed3f26829ca76a00323cc966e23ac8b59680da64a09244d086563"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
