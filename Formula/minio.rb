class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-03-13T19-46-17Z",
      revision: "c7f7e67a100ce35af559e3f49a2ed0b67deaa919"
  version "20230313194617"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57ae0063670d4d1974725667a31683e0ee3878b3f52ee74647e2b33128e74ca5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49b986ca7f62a731590e2adfe1ffb9ffe962bfe2655de0e110594463eb925c4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d7eef906f013c2a7da8120d414d39d09fef22c4e796e17a0d208b2e2b11454d"
    sha256 cellar: :any_skip_relocation, ventura:        "39b1bcc0e8a2bf71aa076a46a98188bce8ab8e954890025e7140a6f80b3aee96"
    sha256 cellar: :any_skip_relocation, monterey:       "6cbb4bbaae34a7c5e14af841b1a717068e0cbed79b69dca1b0b921166427121e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f043ac2d6ae396b881339b83d524747d540b13344362b9c16b5b734fdea249c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2c696d552e2500dc05424295b69460a3cd64be0fb3b10d2965fb47c9a4dc916"
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
