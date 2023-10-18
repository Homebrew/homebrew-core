class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.4.2",
      revision: "7163e61e2309a039241ad40b4a25bea35671ea6f"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7adb9158c20355550e353fbe48924b3335a5a1350b19e2b021e616d19e7ba1e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e702934dc97273c2a9a1b7ac060f20e43a91732aee6742b5e2ead5b7c132c89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "792212f45639cb1dc0494b4e455913f110269340ab5dc3a8257fd227390148e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13cc0b246fbad82aa2fef5ade81f1c252e51a2888818838e68b3be9806ea2594"
    sha256 cellar: :any_skip_relocation, sonoma:         "94fc7e7343b273369619548652add7adafc82a6e4b082193bc7ac949abcc057b"
    sha256 cellar: :any_skip_relocation, ventura:        "61407be63f9d0db462fd1456cfce468c1762ba9fcad6bf506330298a8666d869"
    sha256 cellar: :any_skip_relocation, monterey:       "b258e7996cec0b9ebb261af589f6b1790efda297e79a95769595fb61969567e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c241efa1354f37c1316e76b435d515a243847cce4a35221525bbd25914368607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e06b6d57e4ec9e8eee837fb161636c4b887a6bf68b474433e5114161d528bba"
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
