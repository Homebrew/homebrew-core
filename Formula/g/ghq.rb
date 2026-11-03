class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.12.0",
      revision: "2db7c02043f00d12edde29eb27cac9257d6fcf58"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2f0a8cdd8ccfcb869137b59a606730472a86806bb734a42d84125069ca107a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00ce8ebf064a3286232e4d556915e30a538165aed674d1b065e41344d6a3880b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b7bdaa06d09816e4382c5bc25633512430d0c60871f274b31e58b49c489a930"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cc713660b94e38fbd1018d6aa68b9fd0cc6bbce94c6c28a458154a34e556dd50"
    sha256 cellar: :any,                 x86_64_linux:      "930d6f268113c877750d76ddc47b1ecb32aa55080a377d4d2d1cc35707bf49c0"
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
