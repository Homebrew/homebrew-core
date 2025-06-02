class AcmeSh < Formula
  desc "ACME client"
  homepage "https://github.com/acmesh-official/acme.sh"
  url "https://github.com/acmesh-official/acme.sh/archive/refs/tags/3.1.1.tar.gz"
  sha256 "c5d623ac0af400e83cd676aefaf045228f60e9fc597fea5db4c3a5bd7f6bfcf4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d00192c5ed57c194866906887b7407562b52c191d0db0df2462dfb31b46db3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d00192c5ed57c194866906887b7407562b52c191d0db0df2462dfb31b46db3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d00192c5ed57c194866906887b7407562b52c191d0db0df2462dfb31b46db3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dea65246401fb500e1cdee17b5ddf2b9b06079d736e1de9d4082464b3fbe5d1"
    sha256 cellar: :any_skip_relocation, ventura:       "2dea65246401fb500e1cdee17b5ddf2b9b06079d736e1de9d4082464b3fbe5d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d00192c5ed57c194866906887b7407562b52c191d0db0df2462dfb31b46db3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d00192c5ed57c194866906887b7407562b52c191d0db0df2462dfb31b46db3c"
  end

  def install
    libexec.install [
      "acme.sh",
      "deploy",
      "dnsapi",
      "notify",
    ]

    bin.install_symlink libexec/"acme.sh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/acme.sh --version")

    expected = if OS.mac?
      "Main_Domain  KeyLength  SAN_Domains  CA  Created  Renew\n"
    else
      "Main_Domain\tKeyLength\tSAN_Domains\tCA\tCreated\tRenew\n"
    end
    assert_match expected, shell_output("#{bin}/acme.sh --list")
  end
end
