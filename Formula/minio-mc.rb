class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-09-02T09-21-27Z",
      revision: "f661334f3d61c870fdf55f1db238ea7268175ad5"
  version "20210902092127"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfcfe18ae90dbe6d799bc5a9dc889c41e97cebe5d9973d47280830ca5e98bb3a"
    sha256 cellar: :any_skip_relocation, big_sur:       "60d6c118cb607a6284309eda51aef4ea31106fb4629a7a119665ac0f683b0129"
    sha256 cellar: :any_skip_relocation, catalina:      "068a5d0864603f733ed5658ac809c68e8e6cd30ceee5c6ec3088708ba16bed38"
    sha256 cellar: :any_skip_relocation, mojave:        "f2febb4aa970f3cc34f076461bbdf17ee34333fefe30852681d6fea37f1c8b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dee824206688b02dd677d7269a40421ee793b04f235ec15d435783218a2dc46"
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
