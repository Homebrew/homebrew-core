class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-10-09T21-10-59Z",
      revision: "27322636ae33611cf193a0fe4b5de18f3b096549"
  version "20221009211059"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "547a8380303b60d580d1d4f99a7c345e8fbb1ff78b763969a5fef9aa73de5d22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1da0693f65a3ac8377ceefad435a51da54ad5f1397a5aa326fe86e5d561488a5"
    sha256 cellar: :any_skip_relocation, monterey:       "cbe3e1c266ff401516478cd2356e5fd397923cae3d8d56ed3ce98a709af92b20"
    sha256 cellar: :any_skip_relocation, big_sur:        "ece8e852517629c4709d3a05769a492ea2ad94306263d649b185884933b687db"
    sha256 cellar: :any_skip_relocation, catalina:       "442c8c351599d0169d4493bda2e70d343a5a3999fe9c383dbd49171a722e56f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97405304a42166bfdf1a00e363cbbe1faf9c8d134376ddd503a4f758ae7809d5"
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
