class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.7.1",
      revision: "5bf53dc168693c8640e3de4420295e28d6c9fb57"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0117fe1b7b6855f21707253b478b0033be12786671feb8e90e3f81e1fa165ca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "523ed07ca1f9cd2ef9ab66b5dfa38921845b7b2617a5b09cc588bfae0eefb2e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f08ae84e4c2a9b000ad3e560436203bd0db16ef52f6fe3fca26669da05eb138e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a25da44183619a0d76c077d51e8a4b46321fb1afc36fc2978016c69276facd8"
    sha256 cellar: :any_skip_relocation, ventura:       "9e21d16504a618a01c24669e0ef49cb056dd17e3fe1241f0e4abfa2c6875a178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbfab4fd6aa02014128db3133fb80ef613787fe58688907c217f7990314128fb"
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
