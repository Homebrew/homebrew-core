class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.5.0",
      revision: "5ace929f73e78dd279c6227458b2e9683e8af6a3"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19227d3c56dce847f3e0135a235d44d56e4b01f246aaebe83f9f3dd5fa03576a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6d787f51ecb3db678a8461f8f34cd533204d890325d421f0a813e18ee70fe37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfb60a3ba4b4d3bf073044b84fc9c255e9477b9f02a82c1aaa90ff8804dbd502"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5c599d32f5bea89c4b0b2dcbf523bfc1f5c269b6e2091c370d76235c0fc447a"
    sha256 cellar: :any_skip_relocation, ventura:        "b5f961556625ae239b08935a038e11873e516f841f5acdba2e97fbf9ae2533b1"
    sha256 cellar: :any_skip_relocation, monterey:       "091b5db5b3cd665ca9206829cbaf72119e30753a9e73d57c8ec313161b070351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "315b093517cd382d987944dbb4419e2b1187b5c55c94574458d0899b5b2b51c8"
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
