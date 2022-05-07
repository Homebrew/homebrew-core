class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-05-04T06-07-55Z",
      revision: "5619a78ead66ba651bcbc36df61ef892e470b8ea"
  version "20220504060755"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a350c65f8a001b14a48c482e103af71e04031b6639003e571fa34c2ce0ebe6dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa58c2cf834bed62ec491966c7ef6d4ce7f0abf71d93345bd7e6236dc26fa39d"
    sha256 cellar: :any_skip_relocation, monterey:       "2068176b4fc6bf8ed0e39caf946676a2268b1e08ccf69b320b94d3b39743e5d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f0b5a729a522e400a20991a4edbad75c8142924172f8c8c32034e94a2969f02"
    sha256 cellar: :any_skip_relocation, catalina:       "326eef88a02cf79e8c1e194bb72c53cfbc96ea183e3ee37bc2ea008ee5f7c138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4247863f244ba1c56fb9ffc4dd8d28adfa39831437ca49872b62d0c96da1173"
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
