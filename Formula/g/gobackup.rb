class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "87ad4c89cf1cee047d9c1e68559322653dda62c830408066c954d07c40ebcc90"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4c4cd8178fd7b42c5efe4cdb0a8af8eae612c3dc2cccb3d396c759979f87033"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4c4cd8178fd7b42c5efe4cdb0a8af8eae612c3dc2cccb3d396c759979f87033"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4c4cd8178fd7b42c5efe4cdb0a8af8eae612c3dc2cccb3d396c759979f87033"
    sha256 cellar: :any_skip_relocation, sonoma:        "4793fc54b645330b80fc5a8df570c495372322b40d9107bfa2c2630cddd6543b"
    sha256 cellar: :any_skip_relocation, ventura:       "4793fc54b645330b80fc5a8df570c495372322b40d9107bfa2c2630cddd6543b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8f9c4843e273d3f385b9ce369864b2ac568d9ad2ff7da1ba920063bae4fa2fe"
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
