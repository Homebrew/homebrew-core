class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/v1.6.5.tar.gz"
  sha256 "8fac65f448f6fa75b13984a71d8af94c59c390f6a64b99c58376014b6996b73c"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21569f4657cb427260ba5bb6f796f3a38932840e0cb9570926f868441998c1c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ddffa532dbdb0856335975d9ab55a16fe3652037f8d40e05edff8fb942fcb0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f9cb34a202470d89148870f20c31d27dc9907de2036164720f5b60d26d298f5"
    sha256 cellar: :any_skip_relocation, ventura:        "da44ac4d53090a629d3f02963958210bca3d39cc7ef3ea91efb5f4920a8554ba"
    sha256 cellar: :any_skip_relocation, monterey:       "be169d34d070388999c9de3cf924f62164d2330062bca1285337580a432f9550"
    sha256 cellar: :any_skip_relocation, big_sur:        "577e7fd146229c14de8c56e64b315053dde230931fa6500b848b8fee8a3a0b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea481a851d8eb6c6a75f70b72f7aa344987effa1bf5c38204257d9456b4b7118"
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
