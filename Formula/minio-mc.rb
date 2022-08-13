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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "474e9645a6ef24f1b192de7ad46fd5af6fc829283a63490834e0de22883b305d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7319147e2e433f7dc24963e5bccaffd42840dab05210f2eaeca7b49cf3a2ea1f"
    sha256 cellar: :any_skip_relocation, monterey:       "2ca12455db7ecfc8c071f0954a00bb42f0265ad434bde2c3debf8c3f03ccc8ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "d16cc38fcf04d7854148288efb4a86a0e4c4aafb9119dbf0bfcf20449db8850b"
    sha256 cellar: :any_skip_relocation, catalina:       "ac7d24205a9b198172602b6be78cbba32a55661e638f102960f33775f88c991f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae2712c785512febe7598df5886e67974f79167b7713ed96da62f7be2b6a08f4"
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
