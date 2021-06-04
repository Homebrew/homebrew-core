class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-05-26T19-19-26Z",
      revision: "8d65ee71302e662669bbbf57b834a4aa38c94bdc"
  version "20210526191926"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b4dfc994990226a1a6686c4ccec3d94da76c4593f743169b07ac9cc5733bb3cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "9006aa409612be3c1c28c543e39ca8d54622a4508021fd04414c62d014174f20"
    sha256 cellar: :any_skip_relocation, catalina:      "1b84f65bb776c0bd268f50c9ed9932889b3fc5760a97670292f381ea786790b3"
    sha256 cellar: :any_skip_relocation, mojave:        "b2c49f27365c6994ff181e939dc4f58300fd982cb4f5a3dc6d534daa36a1d034"
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
