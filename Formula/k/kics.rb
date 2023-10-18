class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.7.10.tar.gz"
  sha256 "2566c4d1df0eb3e8a08f1b4e825f609818f2ad831d45753196e6e5738164a9e5"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c05d6d8bad1bf3a83f318faf620d49a59b1f211cb51d11897de45db7199fb19d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "020b433c6ad59a94eb981918d68b891f8b95b7a97810b9da1476411ca12b3a69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebee796af94421578db6fcdd644aae66c9bada49d270b0c7539b3d9ff9c76e73"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5da3ad952d0c21b71d05c164b4cc310eb5a6971ac04d8103a8d3fb57104103a"
    sha256 cellar: :any_skip_relocation, ventura:        "76f2f3fab5e1cbee7e768afd746c23e920bf73bf87ebe1e164bdddd54ca234db"
    sha256 cellar: :any_skip_relocation, monterey:       "838c117d4b3ca2fccee772ccca8276a6bd1fc902170f5b7644a6ab0e0b26b570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9899a41dc5217f35535749b2ddcdc8b32a97f348083143bdca119f723928906"
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
