class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-03-03T21-12-24Z",
      revision: "f13defa54577bca262908e58aa4339969a8e3d34"
  version "20220303211224"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6b2ad381cdbc2bdb8b39f49ed57375accce279f696316e0c953975a0bb08c46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "872ec08b984239efc46a42b61b7c24a05ac75ab1cf1d8bf06684bd8c3a7b83ab"
    sha256 cellar: :any_skip_relocation, monterey:       "6822fd9429d16179b035253f6d13f5f4c9b20b8ec20ac1103d2c3398e9da42d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bd5b99b9640d074785a7dbd97548ad60933cc08a5897ee7864261e2f374a918"
    sha256 cellar: :any_skip_relocation, catalina:       "c3f5bd92e9c78a1df2e9b13147ad3ed949ec624d9f032d07ddaed0df4ac8b925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca8fb1fa57e58ab91c4713a488ed471e6b2d2cf4f85167b62eec3e8d6a078689"
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
