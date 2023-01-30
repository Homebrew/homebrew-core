class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/v1.6.5.tar.gz"
  sha256 "8fac65f448f6fa75b13984a71d8af94c59c390f6a64b99c58376014b6996b73c"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24bb95a9885feee99d6bebccee30d2d8a15d323508f73a5c557d1e5343f5219c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd3d9bb03d31c3a1c48d53973f7019b13264636e9c515ad3eff7e3c56e77f555"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e5795f1deef0d99f8511aad9eb10dd49282882200f43ebf2f789fc0efa7c2dd"
    sha256 cellar: :any_skip_relocation, ventura:        "4a6b1b2cae83b5ea08da7c896fc81e4e252b27cd025103b6ddc5a37f6d0bd141"
    sha256 cellar: :any_skip_relocation, monterey:       "e92da97c2e5e4247c5bf5639bf4eda46b144dbcb91e1577030d93cf4a548bef9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd0edf08eb6fc588261b9ccb70a09e185eedc6891e0b580093a49fc20c4d169c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a37de34065277b0ad5a1cc76487613ae23226b23251281e14540695d07868d03"
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
