class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.4.1",
      revision: "17a60a90078e7de084b5d8473ee1b0e3395f9b45"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5fcdc35224b0e20b8b0d478963dafdbf959709855ba1a0daca8987c8ac7fbee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "816e051f0bc5c73578cb6da49060dd4a50d1846f66f4956468b8c4c8a66d4638"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4ca80281e5feeea036edcefe116d8d4343ab1d50afb2260a8a82a49d38e94fe"
    sha256 cellar: :any_skip_relocation, ventura:        "2ed35e76b1682a9e62bfe00d6e25d866e81756f1df8d9bbfe5a167a74df4ebd0"
    sha256 cellar: :any_skip_relocation, monterey:       "4b6e07aa7f6c18fde824aec219a17f5e1e120f2392091ab7bfccf1cd7452519d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1849add538e2397050493115622f78bc87b98264e034655d61ecbdd3028095a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91edb3f042b18e40a06626daf00e640c0830a9b5dbb0a2eccbf6ca60f665e82d"
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
