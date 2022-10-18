class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-10-12T18-12-50Z",
      revision: "3fe6778ee739504b169743cf43fa7b3010e05b99"
  version "20221012181250"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aae9bf2fa4033990cda6dbaaa41fcbcf2a28e0b001412380ec75380f3b5f1a3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f64e8c7ba212cefe49a01f01b4fc43ec201a859614bee9cc71ff3174da8daa92"
    sha256 cellar: :any_skip_relocation, monterey:       "f1ee4df0f3ff73007dfec4be2552fa7cde4b72bc385592157932b2a8471d4469"
    sha256 cellar: :any_skip_relocation, big_sur:        "1556b80e573376d23c93ae13cda823a1e1ab4635a14be925e864c06ce14c9414"
    sha256 cellar: :any_skip_relocation, catalina:       "b7333d611cce9b29a6bd62f61c620e179d5428b7e25e323c075d35a2f004e2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bef678a147f75314e1c09ce62e78e093bfb49aba67b5e4fb433b593f4070b148"
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
