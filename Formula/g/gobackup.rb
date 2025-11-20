class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "8bb19260014b64488f4f6d795a8e46a34b4b86a62f65e1db7ce14f63644de12d"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bc24a41fe3fc6afc26649b83bb7e4a602cd0575b7ba480a159e73d50f3d356f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bc24a41fe3fc6afc26649b83bb7e4a602cd0575b7ba480a159e73d50f3d356f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bc24a41fe3fc6afc26649b83bb7e4a602cd0575b7ba480a159e73d50f3d356f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a5c782d8be96b05cb4417c55982a69f83ade338cfe101f9fe2fd6f59989c662"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0bd634ed505058de79b7f200c4ede4ebc3753bd1810a5aaf46f9caccc9c3a2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e1fda203d7fa2e946a655fc12a54800ac4174d487f7adaca171ec96b7ee7ab9"
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
