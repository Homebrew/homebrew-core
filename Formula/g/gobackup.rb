class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "20cc0374133034c3ed0ae95b8ea98b98777734b8a823f0409529a949a6b7dcc2"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "255bb91d56da8122c45a264d26252e20fb49d8c6a8da83555ff6443f581f3e30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "255bb91d56da8122c45a264d26252e20fb49d8c6a8da83555ff6443f581f3e30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "255bb91d56da8122c45a264d26252e20fb49d8c6a8da83555ff6443f581f3e30"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1b81dbdc423bc6f1c97a50d60b4a58578523536bb1bb77f4b05a53c0d04e86c"
    sha256 cellar: :any_skip_relocation, ventura:       "c1b81dbdc423bc6f1c97a50d60b4a58578523536bb1bb77f4b05a53c0d04e86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f76c6e3b9b79efb176b3c9a76d2b9ef20dc764217fbfa5b78d143b038a8af8e"
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
