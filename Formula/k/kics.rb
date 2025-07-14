class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.11.tar.gz"
  sha256 "53063b4d557b0ab62a92e144e758b48a3ffb94b083faa06d96870d6991cf55e0"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4a68da0f4975e7044abacb6ab7c3ed869169715c1ddbaf54617359e8b817e96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57e3e34d07d59e13b8f9f967aa271b51ff52355501f485461c771ca6406cb7c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a040df651ef617a4a363358c3696b6078b314a93c9ed490bd93fa1ec5b268fac"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2fcf7f5927dc19385d00f038c326327720e9b363af65f0da63ee28e1d292c39"
    sha256 cellar: :any_skip_relocation, ventura:       "e8879569e93b46b55a9d66d8cc920822f6c101f62d546194ccad46f6f9eb8311"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3b857fd1505368ba23386892751cee155d3effe8e5b6acfad5ded537f018cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e14f70ba282516b0b24cc42a01c50fd8318f8f37335c9ab3c6783b335d1945f"
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
