class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-07-29T19-17-16Z",
      revision: "37a83f23f048e3e1265bac5e56d681f750d5ba21"
  version "20220729191716"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50e8b39d9b7e100465c25f4d85e2af0530fd28fb5e158fb7eb5c4d80944e144a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14db372c8cce8bc176290dfc9405f836c774217be93864f41a158d5628eabf3f"
    sha256 cellar: :any_skip_relocation, monterey:       "e97fc5ef79b21feed5e8551644076d8340e4494c6392eb2e880de598194da66c"
    sha256 cellar: :any_skip_relocation, big_sur:        "13d34568c228ef19d55334d0a0da050c32a5b010ca4b66cded310d454aa233ab"
    sha256 cellar: :any_skip_relocation, catalina:       "9f7ebc95f81a1b5f0c738eab3e21f9677481ee9c84d3763cc03e25fd9f92fa66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "817b49fba2fe15e3d842ff380b1062a491408c3cbe621f8d4dd8134c5fd93a3c"
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
