class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-01-07T06-01-38Z",
      revision: "aed4d3062f80d44384637832ad54c530ec32924e"
  version "20220107060138"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea008d8685ff39877edcf2dd7568d9983e8e834f626ae578a4e9723bc544e52a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc86d8e703b044d831e2749795922a039aed4018fcd3b39b7d45e1cd026eb99f"
    sha256 cellar: :any_skip_relocation, monterey:       "e87f539238a6ef8b93436593862623344b526d20bd27fdf3747775c8406ef4ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "379e4ff6a04b63fe882156d41632d176d867cc9cdbbb70f69c589b613a03dc87"
    sha256 cellar: :any_skip_relocation, catalina:       "0974d8027fe701e44970c46c2d366da360e3361b419d2526fa223b806dd3b78d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dbb3e72e2d98e13651dac16cb4b9c935068ec772d5b4b00618ca5cacf21c048"
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
