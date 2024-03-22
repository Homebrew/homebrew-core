class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.7.13.tar.gz"
  sha256 "6262632cb70fd4d642deb66b1c02ae2825bde34d9020632a9a627c94350650cf"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e98a0b491acdb69a978ee32ed366a64c134c6a5d0218876a59db78bb6126098e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0031ca5434d13e61cf0cae758061b2bff3b3903cc5778e972d62d1b5e6506bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71c5cf147dc8b434e222b5e5573f8e30fbdffc4170b2fdd5f4b7af15d3acc9e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c71f970d2232650b13797850bc01aa74c1d31f3bdbbccdb3b31a9aacabeff31"
    sha256 cellar: :any_skip_relocation, ventura:        "416665c840b5e0cbffad5f63a9cb1866b01d62e3bc5885396fdefbe7a69ff26c"
    sha256 cellar: :any_skip_relocation, monterey:       "d4489f7d79c257cd931bb343ae8f1200bf6c5c2038316a3d09c10ef10b28cfd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c40c05b9da1e335d141f03bdad85c882f57596cf3cabaca491e03024c6d20fb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Checkmarx/kics/internal/constants.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/console"

    pkgshare.install "assets"
  end

  def caveats
    <<~EOS
      KICS queries are placed under #{opt_pkgshare}/assets/queries
      To use KICS default queries add KICS_QUERIES_PATH env to your ~/.zshrc or ~/.zprofile:
          "echo 'export KICS_QUERIES_PATH=#{opt_pkgshare}/assets/queries' >> ~/.zshrc"
      usage of CLI flag --queries-path takes precedence.
    EOS
  end

  test do
    ENV["KICS_QUERIES_PATH"] = pkgshare/"assets/queries"
    ENV["DISABLE_CRASH_REPORT"] = "0"
    ENV["NO_COLOR"] = "1"

    assert_match <<~EOS, shell_output("#{bin}/kics scan -p #{testpath}")
      Results Summary:
      HIGH: 0
      MEDIUM: 0
      LOW: 0
      INFO: 0
      TOTAL: 0
    EOS

    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end
