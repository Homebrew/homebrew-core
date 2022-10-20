class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "c653f4e415842deff453698a642dee7298287f915bf511160d249dfee5093c5a"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01a7e5c15c6bd28a4014f9527020616bb84638f0b18156eb013bccabfe7bc622"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0fa8f3b530fa79921dd116a2c17cbc8d5b760fcb1e698b71579a7fc7dbff5da"
    sha256 cellar: :any_skip_relocation, monterey:       "ebf91042e9dc8601a81cf283ce7c0029a5e308f65effc951c5002550fb734e5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f75fcfa53dad7d0487684e26661e99bd23b36814ef06740d51e98835e731269c"
    sha256 cellar: :any_skip_relocation, catalina:       "bd0f92da421b12575a5e0b79de459a42571971c43c1230193540f16dd010f3a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f530a1db08b881feb08c2f297e6369eac8c3fb2dca2dcee3106ea8efc958c291"
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
