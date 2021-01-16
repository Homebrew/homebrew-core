class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-01-16T02-45-34Z",
      revision: "f1f3003e5eddf7be07d03d2a83037dabb2c55e94"
  version "20210116024534"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e0ed5fa0e27680ac4d370a8f137642218121bcb4d3530ee8032a8223330cae39" => :big_sur
    sha256 "4569218efe545c1ceb9eee72b01a86049b22d58bf97672ea744e182d22628341" => :arm64_big_sur
    sha256 "03c83d63571f8aef4425e0452796a64695952c0efc1890199dc42ecc269da1a0" => :catalina
    sha256 "734a0340d0870377df86eb3e3a8f38a016ae266db402aeda89990c6e663889bb" => :mojave
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      minio_commit = `git rev-parse HEAD`.chomp
      proj = "github.com/minio/mc"

      system "go", "build", "-trimpath", "-o", bin/"mc", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{minio_commit}
      EOS
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
