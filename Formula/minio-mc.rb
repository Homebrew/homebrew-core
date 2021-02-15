class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-02-14T04-28-06Z",
      revision: "7672841f8c58264000758e96d3870caa0029dabf"
  version "20210214042806"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "600314727167655df3cf4fd67f762b86fcc74e7ac5e63d5e7f09490774143a38"
    sha256 cellar: :any_skip_relocation, big_sur:       "61fb4aa3c6609649bc188bbdc1173b829102f42e6284989382015fc12a70b9c8"
    sha256 cellar: :any_skip_relocation, catalina:      "a8035b4f4775ee0146628d1634561aead05900231f0833e196088b11df018a59"
    sha256 cellar: :any_skip_relocation, mojave:        "1d64eb22f25062bd09bccc5e1726937f28501b2fec65d1fe8dd7ffc3829ffd8f"
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
