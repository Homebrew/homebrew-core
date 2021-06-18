class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-06-13T17-48-22Z",
      revision: "2c52cdf27c7bbd57b52f954eb50d4ca353d62f9d"
  version "20210613174822"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8ece8574c71cc3e7fdb2a79a8c8a5ba1f4b0b105c88f1d73efd28e90588fceb5"
    sha256 cellar: :any_skip_relocation, big_sur:       "7cf812e53b0587908e74c3a53dd65db3a38248b410086ffe98291b32cc5d4786"
    sha256 cellar: :any_skip_relocation, catalina:      "07244335869eca58ae410e1630f7c17ea3f5c4e4380640d437f345c6fe9d63b3"
    sha256 cellar: :any_skip_relocation, mojave:        "2e6e5e2580cb2588f859a3b22fcedbd7a0aa736ec10b8270e57c12e1fb6e3450"
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
