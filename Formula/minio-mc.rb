class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-07-27T06-46-19Z",
      revision: "addaf66de8af5d865a6102320727e8a5dbcacdb6"
  version "20210727064619"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08d60ef7dbfbdb194b90fc5abea357ff148c0d2665cf3c15f31821c341bc7772"
    sha256 cellar: :any_skip_relocation, big_sur:       "32daad3d18d738ea15ec1e5668c02e6a094c0c0c58370356a161fb31ee56bb81"
    sha256 cellar: :any_skip_relocation, catalina:      "53e337c29983cb8cd7145bd200aed53380d4023b384321fe6bd88db977b4aa1c"
    sha256 cellar: :any_skip_relocation, mojave:        "b2aedb6f0998f4ca464c7e0bdf4eb87b32582dd2433fdfa3e9b26a5d9b040674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2aebaba19f3e353788c2afbcfc4aa375cbf5a992f5442ddf83c6922de2aa9d1"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  # Support go 1.17, remove after next release
  patch do
    url "https://github.com/minio/mc/commit/855333e4ab24804dd3dcd38988ceaed112ee62f9.patch?full_index=1"
    sha256 "c00d331fd8d420105356d004aeecd17ef4c6332796f53a3e547218b4de7dbd41"
  end

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
