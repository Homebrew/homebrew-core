class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-10-07T04-19-58Z",
      revision: "198bca9cdf237ffa7ec7a5cf3dbc0628544306a9"
  version "20211007041958"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "398c3f44dacebf508bbae381fad12d23db2f67484983a3cd3a350e78202a8de9"
    sha256 cellar: :any_skip_relocation, big_sur:       "4e5e3d6d9f1b1804c54f679d801efd13a58acea33bbf00447552f85caa5ba847"
    sha256 cellar: :any_skip_relocation, catalina:      "6544d64d66da735f53dd7c5d3ec08aacbe1389cb9adab09a474c9552a5a63c8d"
    sha256 cellar: :any_skip_relocation, mojave:        "63b765051debdace689bceb39db90cec21c6a3b7c8dd0679e2a838b7b7d8d70e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4639d9b3e01f04afba7405169f6df10d831c08c17348e35a385d104f706d410"
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
