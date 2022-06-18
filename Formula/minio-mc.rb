class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-06-17T02-52-50Z",
      revision: "0e44ad30db7ee58386117f9bed143418c79d2980"
  version "20220617025250"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65a8d1247a3cdc22ea9ba0100139307c0c42781d70b0542a63b5f45b9d3cddaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf8c974ee9ab5e23a597cfbd41563f73c62dcd3533f47900803fa4a806789961"
    sha256 cellar: :any_skip_relocation, monterey:       "68d3124c5ebdbbade60c881ac16aa21c4e2a048420a612ef8334b1918b78e182"
    sha256 cellar: :any_skip_relocation, big_sur:        "69af5c2fd33a94a17095ddab504f862d20c1c7c938dab0743ad2c2c12be1616b"
    sha256 cellar: :any_skip_relocation, catalina:       "6a036733b26d46834d383661d8ccd86d8d1f932ad482c619b8907752cd704429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76e19ca03aec77404344c37399923be3893e9d994d37bf15abdc8e39e42825fc"
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
