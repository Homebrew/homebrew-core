class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.6.1",
      revision: "a80a252e39cca876a39f73b577b1fc8865e0b5a6"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "747f890e0d13159372b253953331578c9f2c9286a9d4e37e8475d0bc140c1ca6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0875a6a892d93edfe08e43c60b4dd698e47702c41764968488ce80255f091d6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daf26db1459eb4b7e3f61ebbc591836087bbf4780fdb2f45fea9b16dfa6aa22f"
    sha256 cellar: :any_skip_relocation, sonoma:         "efccec6345ca770c4683231f3c0fd13c4e4e88dfaccef0581c1d5eb60ae75934"
    sha256 cellar: :any_skip_relocation, ventura:        "210baf1de3ee1a86f37bd33849f77bebcf8d75baf306b50341f93e4e9eb85e41"
    sha256 cellar: :any_skip_relocation, monterey:       "fa38b9c6d2abb916ce50ac9a686d5c0fc588148a0e49a170d247389e9dd2e6a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3db4d90ee1b04eb3c2e50e65fec1894d9acf2c86a1613862d92c1d8f0df052c5"
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
