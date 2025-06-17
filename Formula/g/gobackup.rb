class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v2.15.2.tar.gz"
  sha256 "29055101709ce22d9a31c33e64f23e895017f6170f83cec0cd92131528ccf207"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d243bfd20d216240ac0fa2d2ecb4f6974f484cbdcb60b465c2d9442055271a02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d243bfd20d216240ac0fa2d2ecb4f6974f484cbdcb60b465c2d9442055271a02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d243bfd20d216240ac0fa2d2ecb4f6974f484cbdcb60b465c2d9442055271a02"
    sha256 cellar: :any_skip_relocation, sonoma:        "287526b952fe7df30ec856351d57051390502a478d95063eb289d438787e6721"
    sha256 cellar: :any_skip_relocation, ventura:       "287526b952fe7df30ec856351d57051390502a478d95063eb289d438787e6721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "350e540e9cc5c9f72c2ab051a58173d021eb4e8574b304f215b7e2a4fd7700db"
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
    config_file.write <<~YAML
      models:
        test:
          compress_with:
            type: tgz
          storages:
            local:
              type: local
              path: #{testpath}/backups
          archive:
            includes:
              - #{config_file}
    YAML

    out = shell_output("#{bin}/gobackup perform -c #{config_file}").chomp
    assert_match "succeeded", out
    tar_files = Dir.glob("#{testpath}/backups/*.tar")
    assert_equal 1, tar_files.length
  end
end
