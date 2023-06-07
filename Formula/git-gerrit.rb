class GitGerrit < Formula
  desc "Gerrit code review helper scripts"
  homepage "https://github.com/fbzhong/git-gerrit"
  url "https://github.com/fbzhong/git-gerrit/archive/v0.3.0.tar.gz"
  sha256 "433185315db3367fef82a7332c335c1c5e0b05dabf8d4fbeff9ecf6cc7e422eb"
  license "BSD-3-Clause"
  head "https://github.com/fbzhong/git-gerrit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f787bba2e4465a7f5df3bebcdb625c3815331a721abc0024ab09b14b868b3ec5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "865ffd990de756622dd9c3bb37fd0f8e7af04eba58bd38013cda9b6a6c551f95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "865ffd990de756622dd9c3bb37fd0f8e7af04eba58bd38013cda9b6a6c551f95"
    sha256 cellar: :any_skip_relocation, ventura:        "89d72fc6229fb8d4a7a1e8e403bbe382bfea7463965440554e517179eeaeed70"
    sha256 cellar: :any_skip_relocation, monterey:       "911fa65cea72dfe849d36ab108a6a36acd1295ea9c8f395a8f8ded8bdd930fbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "911fa65cea72dfe849d36ab108a6a36acd1295ea9c8f395a8f8ded8bdd930fbf"
    sha256 cellar: :any_skip_relocation, catalina:       "911fa65cea72dfe849d36ab108a6a36acd1295ea9c8f395a8f8ded8bdd930fbf"
    sha256 cellar: :any_skip_relocation, mojave:         "911fa65cea72dfe849d36ab108a6a36acd1295ea9c8f395a8f8ded8bdd930fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f787bba2e4465a7f5df3bebcdb625c3815331a721abc0024ab09b14b868b3ec5"
  end

  def install
    prefix.install "bin"
    bash_completion.install "completion/git-gerrit-completion.bash"
  end

  test do
    system "git", "init"
    system "git", "gerrit", "help"
  end
end
