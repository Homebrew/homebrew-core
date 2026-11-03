class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.12.0",
      revision: "2db7c02043f00d12edde29eb27cac9257d6fcf58"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "38acaeebea85bb56897074df03ad9b74a0d7d66d4433025c02aa74f97d06f4f1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2915db5c740619a910fb7020d457d7160d5d1fcd940df4f47fa8da59209241bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "619299634c00101298367b1ba91b78a121f88f7e038d4e154ab7acd0652315b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d9fc113b038a82a329fe6c38c465117f86c3593159cc046f3647a185636f9dae"
    sha256 cellar: :any,                 x86_64_linux:      "4c787e32e7dc46320bb7ea3102b4e7d522fc09e7693f59a67d98025ff98300b0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "all"
  end

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    fish_completion.install "misc/fish/ghq.fish"
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
