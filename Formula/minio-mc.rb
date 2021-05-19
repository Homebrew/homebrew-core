class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-05-18T03-39-44Z",
      revision: "6e251456d2b99f5120f98556f7436607300f10de"
  version "20210518033944"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e04118a9ca544a31758eab246f50357486729325136147359c5051ee331fcc4b"
    sha256 cellar: :any_skip_relocation, big_sur:       "eb3f9e7a0c4288b942623e4acc437e3b84a98e73b290ce51e7f629b21c05fbfc"
    sha256 cellar: :any_skip_relocation, catalina:      "bd172c657d4245f1e12174bc1940651f4d37811c4bd9a5543ad43ec5565badb7"
    sha256 cellar: :any_skip_relocation, mojave:        "8a5da007670a35ccda8f9c31183fe3130b5ae6b87f5b49609863f6354e863869"
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
