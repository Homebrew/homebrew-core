class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-09-16T09-16-47Z",
      revision: "ad4441ef2b4b1d0a6b90b5dd0d71d0423952e417"
  version "20220916091647"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5dec925ed5d0fee307939b39a01fe8deee1a892cd4dbd83d6191bb24c00f4e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e93df70de640fba1a0892d8a77ba9cdce455855ba5cf714b3f79f9588d47383e"
    sha256 cellar: :any_skip_relocation, monterey:       "63d6fc6d61f56788b614a8218c39a4eeb6c7b4ee41bfe5f079d3c9dfb03bc014"
    sha256 cellar: :any_skip_relocation, big_sur:        "a96ae01fbd7de141fa875220759a73996b07a433416da83d0a57fb5b8b8c7c19"
    sha256 cellar: :any_skip_relocation, catalina:       "684b51943e3fb78f873d5135bec6dacf847a946f7a079af837f33332a03cf28c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4be8c85a9dabb2960ed31ba6b6a76c6f132ddf61675e9471bdd206cfc4ef3976"
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
