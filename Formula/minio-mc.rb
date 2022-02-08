class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-02-07T09-25-34Z",
      revision: "dabc6c598e5e1fc6579140adc636beb15164d984"
  version "20220207092534"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80974795215f53375e14957ffeaf5ff1d82798b690464f627901ead04d9901eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6882a11972e638ed3bd9fdf6fe363e4fafcf7c404a29ac203935ba08c9f9c3e8"
    sha256 cellar: :any_skip_relocation, monterey:       "6b38769abb7cb550713b43a4949c18e76912fbfdd0c78ff3159daa0456349a44"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b834a8dbc91b92ed6fd9e6c7c1bd6deb3c6ed9abedec6e5fbf3f2198e794ffa"
    sha256 cellar: :any_skip_relocation, catalina:       "1589e350d5dd5a0bfa5f2689da1a62ce005bb16c30b12cb722efeed5e0e67be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "065e4585e538a440963cb5ed854be8bccb1bef0501cfb7ded3a8d49cff66b25b"
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
