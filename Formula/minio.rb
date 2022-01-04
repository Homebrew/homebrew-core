class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-01-03T18-22-58Z",
      revision: "001b77e7e1f0ee1eb6c8a0f696ee2d71b6036b20"
  version "20220103182258"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44b991864c8f8a933fb83ce854cd91f41a1e450fecb0a94a7adb14e0fad34550"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa11020066acff665df02c563f31d72d24daecf01a8c04799bc3265fd7a59181"
    sha256 cellar: :any_skip_relocation, monterey:       "97c3fea268d4570d15d95707cd4a173f50258b59c799e1479d06b6a41b081d20"
    sha256 cellar: :any_skip_relocation, big_sur:        "c25706d0aa6921573c0ff8eb089f2eccaa708a8a12d5d321ab88185394921d60"
    sha256 cellar: :any_skip_relocation, catalina:       "0009ca071792e18cf62a9a661f5b13264797dd143cf694e4dd39532dcb6667d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c1acc099f59f5637123647bd1021cb1d0cf8ec9178cfb06e771c3ea564581b3"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--config-dir=#{etc}/minio", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")

    assert_match "minio gateway - start object storage gateway",
      shell_output("#{bin}/minio gateway 2>&1")
    assert_match "ERROR Unable to validate credentials",
      shell_output("#{bin}/minio gateway s3 2>&1", 1)
  end
end
