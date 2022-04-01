class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-03-31T04-55-30Z",
      revision: "8eae2e3bbfafe952ecb33904c0d9073871a32169"
  version "20220331045530"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d04991be7927f2675c068ae85c8e3ed8906acaab3600144c26c4d87a50cddf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3ad638cfdddbfae63aae9d3e68aaaf52bb28b4193c6e0897a8e8297c3ab9da5"
    sha256 cellar: :any_skip_relocation, monterey:       "1fbbac550d21f63b655d6686a6ffd6a54f16c10a78eddb41cd47c226c11974a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ae0e3f3cfba2f8cdc8185af5f43c3ace8b3777e1a33bfc115b1ec388be1b94d"
    sha256 cellar: :any_skip_relocation, catalina:       "8e38d70885a592fc6d16937015a83b7c3070326a3c198217f64ce037d53cca7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88efd2048d5a4621ef0202bc8f090855aec5cbce9d19af8c3fedbd1d5604cbf8"
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
