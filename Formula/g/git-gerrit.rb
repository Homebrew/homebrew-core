class GitGerrit < Formula
  desc "Gerrit code review helper scripts"
  homepage "https://github.com/fbzhong/git-gerrit"
  url "https://github.com/fbzhong/git-gerrit/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "433185315db3367fef82a7332c335c1c5e0b05dabf8d4fbeff9ecf6cc7e422eb"
  license "BSD-3-Clause"
  head "https://github.com/fbzhong/git-gerrit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d8c69cdc736d1b7d2a3977b735cca39493d5976c7c19abc3e7bc91e80712ecd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a80a111e62621f131aeb728ec3c4778a25a838d4ffd579b0921e3961c18cfaa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f787bba2e4465a7f5df3bebcdb625c3815331a721abc0024ab09b14b868b3ec5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "865ffd990de756622dd9c3bb37fd0f8e7af04eba58bd38013cda9b6a6c551f95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "865ffd990de756622dd9c3bb37fd0f8e7af04eba58bd38013cda9b6a6c551f95"
    sha256 cellar: :any_skip_relocation, sonoma:         "94172c972e80decf5a14588dbe9e66af179fcd3f2ada9c3ca44e4337c274a906"
    sha256 cellar: :any_skip_relocation, ventura:        "89d72fc6229fb8d4a7a1e8e403bbe382bfea7463965440554e517179eeaeed70"
    sha256 cellar: :any_skip_relocation, monterey:       "911fa65cea72dfe849d36ab108a6a36acd1295ea9c8f395a8f8ded8bdd930fbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "911fa65cea72dfe849d36ab108a6a36acd1295ea9c8f395a8f8ded8bdd930fbf"
    sha256 cellar: :any_skip_relocation, catalina:       "911fa65cea72dfe849d36ab108a6a36acd1295ea9c8f395a8f8ded8bdd930fbf"
    sha256 cellar: :any_skip_relocation, mojave:         "911fa65cea72dfe849d36ab108a6a36acd1295ea9c8f395a8f8ded8bdd930fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f787bba2e4465a7f5df3bebcdb625c3815331a721abc0024ab09b14b868b3ec5"
  end

  conflicts_with "gerrit-tools", because: "both install `gerrit-cherry-pick` binaries"

  def install
    prefix.install "bin"
    bash_completion.install "completion/git-gerrit-completion.bash"
  end

  test do
    system "git", "init"
    system "git", "gerrit", "help"
  end
end
