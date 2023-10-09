class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.7.9.tar.gz"
  sha256 "3ade6ca8ef202778ba756091acbd4522414beee86d7a832edc29d7e7b8462b19"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79cd976f9b14b357d6f99eafb1596aa068b87c2148284e09f2ef4ed2674be92b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "221372c904b44084bcf01446e80b013a7916c0bb08edc8eb46ed72704fd4e35c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28a5ab832721d1e36e4e3535017cc24934078841d4e40d05aa9a56b2fca61d3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "49a52f58cea56e63147b0831db41b72ff1b3c8e3e17e3d26089cbf703f95198b"
    sha256 cellar: :any_skip_relocation, ventura:        "1fa4889c53a2337deeb473b9e2ad60037af25b26b30a4942cc55d70395bf05ce"
    sha256 cellar: :any_skip_relocation, monterey:       "94280b2fc6fc4a0334ba93156c647a61706f12db99481a4223852d9768d13703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8b75cee7080c66bd099a165ffb63c8ac730419041738ffbd40df39f62b10802"
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
