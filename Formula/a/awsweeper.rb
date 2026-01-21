class Awsweeper < Formula
  desc "CLI tool for cleaning your AWS account"
  homepage "https://github.com/jckuester/awsweeper/"
  url "https://github.com/jckuester/awsweeper/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "43468e1af20dab757da449b07330f7b16cbb9f77e130782f88f30a7744385c5e"
  license "MPL-2.0"
  head "https://github.com/jckuester/awsweeper.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "57cca26932b44660312b377bca14d2f3fdde698d215c127f4be5740304cb61ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f22735ca83b553b980c8c4c965b82c74661f63b05b42535f1cf182c6e80d6eb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5010b86841f22dddef64df08c14003a9f8b67be8799a2fd2c25f123b4d87404"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6aaf2bf93c063a5ab9d409f70d77ad32d5c5b8d42f3b9d2b167e83817de89baa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dabe2797d6b3a7f40fa31dff1fc8bc7f7c94918f024f6f866c9fedb43d8ce485"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4b48419aaa4619449078a64b28ed9bde4b3bb1c05cf096d6852fa92596f2260"
    sha256 cellar: :any_skip_relocation, sonoma:         "483afd6a7be152d00165c0608892c710ac465e1437fb8fd555e260b06693dc99"
    sha256 cellar: :any_skip_relocation, ventura:        "f45b885d958f4b7752e02dc778e64d88a604021bfb0635a80444ff07c78f2e95"
    sha256 cellar: :any_skip_relocation, monterey:       "54bc928c085313ad7b2cd353bbf4b7e49df992527526348ee0eb01437f9ca87b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1855fe15c7d95a0dddf4487692bf75d6dc234c3ecd25457dffaeab3a2312ece8"
    sha256 cellar: :any_skip_relocation, catalina:       "76710715dee67793f3715dc1a902b18f259b4ed4b42515fbf13b641339b1f899"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6509b1bdbe77f14394f17818f3956b0bde26493eb49f1ad0088f4873cec209d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81776b638e309f839a362f70ba7d0621c2ca9e80f6472f334c5472049cbc3374"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jckuester/awsweeper/internal.version=#{version}
      -X github.com/jckuester/awsweeper/internal.date=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"filter.yml").write <<~YAML
      aws_autoscaling_group:
      aws_instance:
        - tags:
            Name: foo
    YAML

    assert_match "Error: failed to configure provider (name=aws",
      shell_output("#{bin}/awsweeper --dry-run #{testpath}/filter.yml 2>&1", 1)
  end
end
