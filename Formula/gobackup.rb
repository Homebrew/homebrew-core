class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/v2.3.2.tar.gz"
  sha256 "3b2c85596fdb3c9f3c4b991a1d338f06ae8083ca09fb09b7eb26c929373d31c1"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a699ac41d4feedf4f0f2c94db61f159dcfd8c48129d4132a3b3bff06c3d98e26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a699ac41d4feedf4f0f2c94db61f159dcfd8c48129d4132a3b3bff06c3d98e26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a699ac41d4feedf4f0f2c94db61f159dcfd8c48129d4132a3b3bff06c3d98e26"
    sha256 cellar: :any_skip_relocation, ventura:        "8b23fffb65a9101b31e577bc63edcc494f76266ac43660e74b403b51e71b26f8"
    sha256 cellar: :any_skip_relocation, monterey:       "8b23fffb65a9101b31e577bc63edcc494f76266ac43660e74b403b51e71b26f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b23fffb65a9101b31e577bc63edcc494f76266ac43660e74b403b51e71b26f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8392376de4eabf3f8c666f8c3d9b2f67660427a53f2f25acde1885d639aefb5"
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
