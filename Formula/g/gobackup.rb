class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "b35d47e4f8cbe1c11ae2a5af1daa35dbf0d5442fc8f977a20b4f73f28833d24a"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f1ed3ee08a3489d5cccdce104fcf12b0eaaa1124977886a623a8eb38dcd7293"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f1ed3ee08a3489d5cccdce104fcf12b0eaaa1124977886a623a8eb38dcd7293"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f1ed3ee08a3489d5cccdce104fcf12b0eaaa1124977886a623a8eb38dcd7293"
    sha256 cellar: :any_skip_relocation, sonoma:        "80d4e8e2c5bf269e6a180172789292aa7958dc6cf7c784eaefb3275c4fe77180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d15b0f57c71e741447c1fa07c1b79d8ab58375a208ac26230660b478ef79b495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd1a250cfefb7564c9c9d7a8b96f6170643bd6c2371f5c87c8d79d553ea4707"
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
