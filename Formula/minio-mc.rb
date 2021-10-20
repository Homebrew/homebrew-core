class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-10-07T04-19-58Z",
      revision: "198bca9cdf237ffa7ec7a5cf3dbc0628544306a9"
  version "20211007041958"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9cbb19bf3e1d6bfe5967aeb440cf46ccdae636c6083e2baafa15fe6a0e95faf3"
    sha256 cellar: :any_skip_relocation, big_sur:       "7e6b57c2ec328e6ac7ff981e49b19a06a6feca5a9778ec1cd1792eb9b2a90d4a"
    sha256 cellar: :any_skip_relocation, catalina:      "bf2c25fc778cf1ee4198b63bfc4d5d6023497ed10abb3dd2e39ac21587f29d97"
    sha256 cellar: :any_skip_relocation, mojave:        "a7a6ceb98971efcf3636735f30db63c3185240430d88ded0d1706a2405612eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b70924975143d520e4fc5502662a3d6695c1739d235eeb262c99c5f3cded151c"
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
