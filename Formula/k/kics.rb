class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "3d34aff9d22708eab32e2e7c17cb4a2a6314633091b7eaf640e259ab8f1b3a26"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf5e6ca605d4502416cd4492b897f1f95bfd917761778a2058410f9c95f17a9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "112a40632a5eedca863de958f2a77e6a079e5207ed666307c2f059c095d4aa14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19dd9283f8028c3266381d2cd63986865185a9d513b007a8a0797e3cb0e232e7"
    sha256 cellar: :any_skip_relocation, ventura:        "7edbd1f245260ac476d228eb2cadc6af4d8d8522e50f74e76cba8a7ea3463a55"
    sha256 cellar: :any_skip_relocation, monterey:       "24a5882c23503ba3abe5c19d23b9fe38b116e76f94d26de81b3bf6dc6917eada"
    sha256 cellar: :any_skip_relocation, big_sur:        "38e86efc2c4c54e1b927343e511caaea5276ee2968dbcea6f743ee2f1496db29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c3244938c7c1c39d1eb13721d18ca42ee50a8c81d7786ac4c90647ff7fa9ac8"
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
