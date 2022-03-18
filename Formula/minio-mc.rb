class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-03-17T20-25-06Z",
      revision: "84a7b83eda09b25909d583e7e9fa437e2965e9b8"
  version "20220317202506"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c65aa2dfb965398ab86ea9ea1e5ba470447c243424d6a9c03459a276eb4f808a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60d08e73843da318d8825dca2ebe8d9dca255c0d4592b3b79f31552a31614c97"
    sha256 cellar: :any_skip_relocation, monterey:       "e056f1b194813187c7259bcbcba2075ef918e94a97bcb1a381281771288106b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "484a8ab4af6a42173766f057094b5823b1b84ea47ad11c557d2ce519f01aaf18"
    sha256 cellar: :any_skip_relocation, catalina:       "3d27d693912d6196c43a2b1bd9d7db24be62a8c4b0c3b09bf04b524090b56443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66a0f7729932c8ebb2d031521aaad96b782433b76dfe67466aba15e5c23107fe"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"

      system "go", "build", "-trimpath", "-o", bin/"mc", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      EOS
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
