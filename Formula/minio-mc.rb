class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-01-16T02-45-34Z",
      revision: "f1f3003e5eddf7be07d03d2a83037dabb2c55e94"
  version "20210116024534"
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
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8dc735682796813d141f070e85ad0fff9876acf17ad0c46869fe4cf7362f18ce" => :big_sur
    sha256 "cd088183559eb50d553dcc33f86f1e5a02f5bfb3d6bea1b1194bc87eac3f96f7" => :arm64_big_sur
    sha256 "a7b5a51965913f2ef304827e99fd2d2390ed5bbdf1ef52a147c16669e6e63873" => :catalina
    sha256 "cf9f3920d8cb20304784d07963a4560b0ffb0bafcf50bcbaa13c280a23e3a0d7" => :mojave
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
