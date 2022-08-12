class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-08-11T00-30-48Z",
      revision: "c2c2ab4299bbb243c55644984392f1c39af499cf"
  version "20220811003048"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08f26179ea424dc60eebde486527c60aaa8b379f1e708bcc7c25b9e055f373fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "114bf0f4329d86010a7514e5bf4f98b4579a976bf96dc48c19c1cfca489d1639"
    sha256 cellar: :any_skip_relocation, monterey:       "61b5bd0eacbd15fbc6b8272f32bacf9f32d824a17fb9c79732ee1798cbfda143"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ab74a2d4f133adb6405c41b601dd66d63ec2ea627862c4776cb39de4c308cd5"
    sha256 cellar: :any_skip_relocation, catalina:       "eaecb6daf3d2c07cc4f78dde96d1454e49487d7d71a29bb84890b9cf6ceac081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1132f7180e4c1126b45a35caf3c92fadcd4b6c749a3b1bcd01afd8c6c0e5a6b2"
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
