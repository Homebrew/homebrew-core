class GitGerrit < Formula
  desc "Gerrit code review helper scripts"
  homepage "https://github.com/fbzhong/git-gerrit"
  url "https://github.com/fbzhong/git-gerrit/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "433185315db3367fef82a7332c335c1c5e0b05dabf8d4fbeff9ecf6cc7e422eb"
  license "BSD-3-Clause"
  head "https://github.com/fbzhong/git-gerrit.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae518d315b919c27305591d1cc24773926b1a947da589b0e50146c98ff138997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae518d315b919c27305591d1cc24773926b1a947da589b0e50146c98ff138997"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae518d315b919c27305591d1cc24773926b1a947da589b0e50146c98ff138997"
    sha256 cellar: :any_skip_relocation, sonoma:        "843601d279865025574a23dc00ae8e8bdd222a2d705f04ec8939af16aa2c19f5"
    sha256 cellar: :any_skip_relocation, ventura:       "843601d279865025574a23dc00ae8e8bdd222a2d705f04ec8939af16aa2c19f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae518d315b919c27305591d1cc24773926b1a947da589b0e50146c98ff138997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae518d315b919c27305591d1cc24773926b1a947da589b0e50146c98ff138997"
  end

  conflicts_with "gerrit-tools", because: "both install `gerrit-cherry-pick` binaries"

  def install
    prefix.install "bin"
    bash_completion.install "completion/git-gerrit-completion.bash" => "git-gerrit"
  end

  test do
    system "git", "init"
    system "git", "gerrit", "help"
  end
end
