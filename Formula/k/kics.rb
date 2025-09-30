class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.14.tar.gz"
  sha256 "36109bbb66ce4561e2a06f0403103085f07f42d9075c7cffd757d06aca925712"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63bbfcb26d029d13d4275f122193039e53c62941156aa712f3b55b67798b27f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "175896e5cb0e2634d9aff8f4d72a8fce62d20bf61ae6b9f38727f433682d3386"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82c0457634c78c7b32837609f54ce6eb9b65307ee5db4334cfb9e2aa8946eb96"
    sha256 cellar: :any_skip_relocation, sonoma:        "8db17bd866763ec9df4275ff29bc0ddd278800a02080474b47ff70c339bf393c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4ad2a9d20af6ba2422307861471d386853f71595bc50f437d3cafc9c1fca591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c61238770a255473044f5f3d449d2ed3196874c6be565feea38e0c149c689929"
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
