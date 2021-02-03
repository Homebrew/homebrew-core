class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-01-30T00-50-42Z",
      revision: "ade302d9693ff25f1ffa5e018ddbcb6dee9cc8f6"
  version "20210130005042"
  license "Apache-2.0"
  head "https://github.com/minio/mc.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9883502b95ddc9a825e1431489b881e19baecb3f8f3988e6c392b99f3a1d0e08"
    sha256 cellar: :any_skip_relocation, big_sur:       "b5e9140519d8c3b99950a316ecb63b2c8baf543c7e45f58b8e39d3826db934b0"
    sha256 cellar: :any_skip_relocation, catalina:      "0ee86f4cc0af50d35aa2bea0b9168edd0a0982d273ee551a1b6b8384fcbd83e4"
    sha256 cellar: :any_skip_relocation, mojave:        "8672bfde6d1f4ea6c8d98bb3dd44c268bd0f8eafd221804da89f63dacdb892ae"
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
