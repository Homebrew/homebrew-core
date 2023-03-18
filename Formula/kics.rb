class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.12.tar.gz"
  sha256 "cca679b0cb620617cc58740d2a4f566514d26a2e7d746a1fde41b55bb61b1ebd"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cef20822a52f02e5583deec8cb5fe164fc283f2cd40db84c7e94f6967f52cef2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6764c94190e6d71c5e81ac725d95e3e902357b90b8a08244e083635fae2c4170"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9f82e1e80904768d55cd0e644d49a1506dfe47c009aba96ff6734b42b699820"
    sha256 cellar: :any_skip_relocation, ventura:        "1dc601799c08b8f7a1c99b72de0fd34bb9660a553b2bff7ee45a119c333c41da"
    sha256 cellar: :any_skip_relocation, monterey:       "e1d55397a0032514efa6a4d852062c6299c1cd0f0961c4c838ee145c82ad66e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "622dfd6c3ecf6f491b712d5c7a4d9acfb8e435718609120ea73b4c8c75033960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac40ac87eed69bbb31fe596e05f35ab8e9a3ad43858e9127270b60d856944879"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Checkmarx/kics/internal/constants.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/console"

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

    assert_match "Files scanned: 0", shell_output("#{bin}/kics scan -p #{testpath}")
    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end
