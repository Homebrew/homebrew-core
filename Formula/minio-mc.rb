class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-01-29T01-03-27Z",
      revision: "829153f47c515e290d34e3f791f9a98706861c83"
  version "20220129010327"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cae8cd3506d34e3176b93b6272a026e5e2a2e99ca7e7ebde71997af9f962c11b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17b421876574d8224781959e899569b69081b571e0794790b18e76a71ed60262"
    sha256 cellar: :any_skip_relocation, monterey:       "64ea012d215bc1535aaaedd9060c35e0a7d70b1491802eee99801167a3c42063"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a6d96a7c7f3c47baff0c1553c4c5829f494cc000b655acae23af361d391784e"
    sha256 cellar: :any_skip_relocation, catalina:       "64ad62038b585fd01d05435e7b27b508a0c7cc6d0872e285f53fbf4f125fd6c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "055ffb86c7f89faf81d9fbfc4731fe81b10763c56d810bec0c1ae37d31d1e6c3"
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
