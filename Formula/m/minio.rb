class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-03-26T22-10-45Z",
      revision: "8bce123bba10a3880deb490bab219d5807da725a"
  version "20240326221045"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f29316ec6f22e0f193d7ec7350dbfbc271a5f30495f173b763498b5bdf0ab2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab7553fb62d95186152cc2c8abe9c47faf7a20857b3c866a9cb87373669ae59b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc1429e5b3670de604f2eb47f79d2f27d1fe8ca6262dbfae33c401376e63e770"
    sha256 cellar: :any_skip_relocation, sonoma:         "862b1c5c947ba44a8745b1851966c50f011315eb2695f402eb5eb6615f8d23f9"
    sha256 cellar: :any_skip_relocation, ventura:        "4edf60552029f6c7329b125ac883530a862eca741c03d3d20893ec7232babffe"
    sha256 cellar: :any_skip_relocation, monterey:       "18048f9b427a385e4c43cb67b617fe481b4f1efc545864ccba6c95cc46cda24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f7abfe1800b681c92c1a595ca274f5d7256acc930d2e893630eb7cd64ed3f77"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub("RELEASE.", "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags:)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--certs-dir=#{etc}/minio/certs", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}/minio --version 2>&1")
                   .match(/(?:RELEASE[._-]?)?([\dTZ-]+)/)
                   .to_s
                   .gsub(/[^\d]/, ""),
                 "`version` is incorrect"

    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end
