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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e38fbaa072d46fd85c0d27f5abc04b3f2a6d5b69f0fc8b039670c72ada7f7abd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc735bac922b8afc5e04d3a1e6ef8f041f57972179db1c22b391f9fcba6fa3bd"
    sha256 cellar: :any_skip_relocation, monterey:       "c705e42dfee4dd6fd1d7dea6368ac6c37f1319fcaf7c1586250626d283a0f3a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c978ce638ce9ef036ebcd041d4f693e18d20b6d5e22a33c22e118fef2500fe2"
    sha256 cellar: :any_skip_relocation, catalina:       "b963112358e4b4c0e092a6032a0b3fabdb2fd0f9040a0fdd57c98b804ab069e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4011526d5405f5a610849d38f40f51210228f59bdff01705dece5419ba2362d6"
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
