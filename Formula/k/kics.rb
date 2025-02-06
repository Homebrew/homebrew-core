class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "f323dfaaab2ce1fa25251b93910801ddcf66ff21fca13831eb89f5f6c1d6358c"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7be073690ccbd41b5ac432bdfff3df615b01c0c1fdba19d1235836739876fcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71da703ff26469210d9299eed2f9444ba2fcb3c9f01154de913f0eb5408ca04a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fe4afebd40747ccd7743047c30553bde9cc18e36ffe7b098d9b22f05d3c1431"
    sha256 cellar: :any_skip_relocation, sonoma:        "bee62275f2fb7830ba8ea4c46b04de6074416308f07b1fd3bcb88c2ca45984ed"
    sha256 cellar: :any_skip_relocation, ventura:       "906a6b6c89a09579a3a0515c061b4ac732d64c4872f4e643d242322b0bf25f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5e93de85ef7f33432f45fe08e2c3c6829a051caab189121486356874e0bdacb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Checkmarx/kics/v#{version.major}/internal/constants.Version=#{version}"
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
      CRITICAL: 0
      HIGH: 0
      MEDIUM: 0
      LOW: 0
      INFO: 0
      TOTAL: 0
    EOS

    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end
