class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/v2.4.0.tar.gz"
  sha256 "d47605a41f4644a5b180ec5a747f9ca429b32adeb79f849ed4142f6c3d39aedb"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a857622c7c640a66cee5c7d68d8c24bddf8bc7639e6539cd9882591461bb536"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a857622c7c640a66cee5c7d68d8c24bddf8bc7639e6539cd9882591461bb536"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a857622c7c640a66cee5c7d68d8c24bddf8bc7639e6539cd9882591461bb536"
    sha256 cellar: :any_skip_relocation, ventura:        "6673836cefcc6f1adb32cabaa1ed7024580b9af4d94b944dd884a94571191641"
    sha256 cellar: :any_skip_relocation, monterey:       "6673836cefcc6f1adb32cabaa1ed7024580b9af4d94b944dd884a94571191641"
    sha256 cellar: :any_skip_relocation, big_sur:        "6673836cefcc6f1adb32cabaa1ed7024580b9af4d94b944dd884a94571191641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd118a2ff8092d2adce4428bf33930917deac5ef9e8bf9ae0cdc473942cde037"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    revision = build.head? ? version.commit : version

    chdir "web" do
      system "yarn", "install"
      system "yarn", "build"
    end
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
