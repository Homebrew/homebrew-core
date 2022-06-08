class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.5.10.tar.gz"
  sha256 "eed7ecb324d5ab84355abeb8a3aa73403d0ab8e49e41788f145fb0bd586b3cce"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "607521e41ef78a315fe6fbd7e74c44528338d6ff130aa7df1b663ec626575d31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad584ccfbcfe63cca2c22d48f7a6aa2d071cfe880fed8d119a07dc143bc8e784"
    sha256 cellar: :any_skip_relocation, monterey:       "b88a3df5b71e6db4d76c5d8322725b67df54965fd1dba0a8e0f958f3b203b30b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3c22c39e395c1d0b7d23cd8026685f6f8ad2574948d1638a6cb0b98933a3328"
    sha256 cellar: :any_skip_relocation, catalina:       "704a36d09cea00d88656656c06c9701dbbc1db9649bfddd449a8cfdc7a086016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cf7dc78f6543e7cf635fb1c3ea4cb42ca9c59c9a5101a7aead99c7b0b86aef4"
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

    assert_match "No files were scanned", shell_output("#{bin}/kics scan -p #{testpath}")
    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end
