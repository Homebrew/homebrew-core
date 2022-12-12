class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/v1.4.0.tar.gz"
  sha256 "0e75fe12a5d9765ab968375a1f94b0ddbea7d58b19a7e5f3f324e8becf353705"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ed792b4e9d5b2c6dd98ea39726c425a340bfe7176186bc55f577f90779b0b1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44b3caf15b4b5add1e35a540ccff60a6ce68888ff550b136f07c449c76cc09e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8f7bb47d0f5c660d54eec4257dcc8c585c803311edec35b5ea42958360e0d11"
    sha256 cellar: :any_skip_relocation, ventura:        "f53fecc06fe5ce0bc3bb040829867e1666c8bdf9cc2e863975e17b65b6f43e42"
    sha256 cellar: :any_skip_relocation, monterey:       "dcc6ca4b45a48a5fca7bed89f766fdacccfd0d3498fc725d248ed9c51cbea19f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8d911e38d7c03f61239b45d52ba8b5383bcc0d915e7e93e80ca4ac972651389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9b74eb950ea8ed286f85e66f489704a696a02333628b16b342babfa7990dfaa"
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
