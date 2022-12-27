class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/v1.6.4.tar.gz"
  sha256 "ec58a7744a89eaf407736974a69430f43f9179c3a38703f3e1455bcae6ea87d7"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0614ef6d69250a45e1f7d2abebe0498adf971c09f2a0198229a7d092903e7a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bd4b2bd2bd24f2d8a4c868eb5303e991735ee4dd1bec0ba7a6a8b00df05dfa5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ff002a56517eb35009bf623cf5689de0e6efed404d347fba40dc931c10443df"
    sha256 cellar: :any_skip_relocation, ventura:        "f6c8695c076760ddca425f2894cdc173bd9ae46349dd30bb8b3b7f49991b8f39"
    sha256 cellar: :any_skip_relocation, monterey:       "74644803c1b80ccc0f6076fb2707ef0b8ea91854eeebd4854c143603fb235276"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4c611c5c8fd89d73c90eded7b8994649f0e53dd7541dacf510d17220aebc013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6062e189ee4110b4c4aae3edb8845af4725f147e22016c9bdb9f3373d890481e"
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
