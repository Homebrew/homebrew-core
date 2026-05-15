class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "dbc2d4fc9371ee7db5bf6a85578aaef3eb8c22802babe37c279ede7c337faf63"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ecb27ca04dbf8a8fc1ea5e236205bb1d09c11f747cb6b2fcadb80d02ab48c51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ae30b7b267b0eede0608df160078e04b3958f86371002b4f671635575927a9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "203548195bd5447c950241cfbf3aff0e587c36959edc25600df6685ed94b0b1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7864c81f611bb8c7970ad9a87c429280dc06885a5c7d8327542e2e00d9b65438"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97678816b94ca57228c60edae76125f308f1a8ce20229286fac9c77387910335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a719968301e42c763e39cd1a3e17406a7e4d64525a4db3274e5d11f4bbf6bf82"
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
