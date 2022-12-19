class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/v1.6.0.tar.gz"
  sha256 "20e548808c6030d6992bfa7fd8644a3fe761d283c4a1bf9f8deb5e2830049f92"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec0c59916c04c06a51ff63d0c976c75aa25b435bdd65579f32f8d30bb9123e12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1108de884b3508aa9734afd70509ed31c1a8ea91e43647ff6ac2f0b352bba46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b70392e5cdbb192ec383153e590989d69423475e650a42d342efd93e26a78480"
    sha256 cellar: :any_skip_relocation, ventura:        "84efa6fa2058a45b3845d78c56d89bafc463675ed7ba34b5652d79d4e20bb9ee"
    sha256 cellar: :any_skip_relocation, monterey:       "b8454360f7aeeb63d516da34742f564ab738dff0cb69c6cabe3d368509bba480"
    sha256 cellar: :any_skip_relocation, big_sur:        "f485e27cf6929f1ab4341333ef4e852ef6e47c28d2bf5980be2db5fcda0f5e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ad8e44f8ab1065bb6866e63bbfe0b31f944ebceecfe6dca6c6292e5515fde47"
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
