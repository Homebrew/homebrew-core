class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/v1.6.2.tar.gz"
  sha256 "df8f463fb082d78b8e704b8f5eec16305e23069e12d4b9d86dec785aa0c74711"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5b5b6d71f0ec032891de427336b920ddbd4eb8b08f37b9dd85f86a2f266c52f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0107c62735cc74143cd43e45c80d1b91f5e6eeeabc052fc26f54d0d9956db0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b532294b186600d9aeeca92834138f70072e1cf472981fe05a0d037faf1587f"
    sha256 cellar: :any_skip_relocation, ventura:        "8a356fc38734242ce481fcfdc17d14307449019a4a632a56f76b259b96560159"
    sha256 cellar: :any_skip_relocation, monterey:       "245b31837094559c0d27dffdf79781108578925c50f5fe4e03e31971425f2050"
    sha256 cellar: :any_skip_relocation, big_sur:        "7af02a4df0810f1eb99a68224158e60532af0afb150b4ab9b700b6f6e685d080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9f6f65870fb06338d2b590899a52fa4f446e9602ac151e1efc1554bea28832a"
  end

  depends_on "go" => :build

  def install
    revision = build.head? ? version.commit : version

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{revision}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gobackup -v")

    config_file = testpath/"gobackup.yml"

    config_file.write <<~EOS
      models:
        test:
          storages:
            local:
              type: local
              path: #{testpath}/backups
          archive:
            includes:
              - #{config_file}
    EOS

    out = shell_output("#{bin}/gobackup perform -c #{config_file}").chomp
    assert_match "succeeded", out
    tar_files = Dir.glob("#{testpath}/backups/*.tar")
    assert_equal 1, tar_files.length
  end
end
