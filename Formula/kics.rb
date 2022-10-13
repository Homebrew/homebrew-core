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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f32b81a0b047f2318b69f5a39230f7363c1aec4d79a8282c48676921e086dc3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37b3d7792695bde00c2626b233c42ad58195b7e89d4adfa7e41b00297f2f6cf0"
    sha256 cellar: :any_skip_relocation, monterey:       "84b7bb1fa2971e213e838abfc85e1a00dc6436be5dc25f7fee478650dd1c2fa1"
    sha256 cellar: :any_skip_relocation, big_sur:        "628c2b1ce2eeec0a55ae1f47a6bfbce57330a535f7ffa1d5c11326584dd6a095"
    sha256 cellar: :any_skip_relocation, catalina:       "dd5b0ee509605a5f585779258dc2d8c30da234c92168bf6158762bb7fe5f133b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40d8a25a6085d56f1fec851b2514cba9291cc538c2916fca7847b88857b42202"
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
