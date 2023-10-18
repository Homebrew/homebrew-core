class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-10-16T04-13-43Z",
      revision: "edfb310a59edb6f1b645fc456b03dfcea770e1b4"
  version "20231016041343"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19a628a2020195df23d1becd24f3d455ae01c7f0a435cb26239525f8bb28b3d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "343acaac706a38425a281b7c1f2ab620cdd39c5915b45a65bb22ef8469722497"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9f5b6fa27031bf4607c0b007c14cf54f1f5f32ef4f3a8fa65b331b21c74891b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0108cad8fb9315d73c8a6a28d6c9e706bf47d934ce63b38b2dcfbfc5c97508f"
    sha256 cellar: :any_skip_relocation, ventura:        "619ec45190eec5d8435dd06c3c2f2473b9fcc71cc88bb66d991aea0737c62d10"
    sha256 cellar: :any_skip_relocation, monterey:       "44baddbce6889fed9dd570bcdb006575a74c6e32b1c1e15f7ef3033d5fb6fd59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd7ec0febc368cc90fc239a3af72faf98182d1bce243c8b4d2e7308835b06296"
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
  end
end
