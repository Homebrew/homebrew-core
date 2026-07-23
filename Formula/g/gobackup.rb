class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "dc3ea58f3e2ac91dbf91dc7d7c5a704c03446fec757c1a88625ffcdbe2eedf9b"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbd9df498f326c7bccb982ba5f85685dd4cc5e8c657d25239b1e35c0347d01ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fdd18b75915ead2549f90bc2db5250e08ef8401117adbfaf3dc583e30a7058b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1b459e9b9ee01f64392a343013bc9903269fa5b03300b84eaf548595285cc8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7dc4b8adf204eb072d32b98d55872d574dd77fefecaec91181050d86adc7ec3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8ffd8fcede81ccb74aab442bc668d6c05b3ee7b2d9f1dccd90d715076c84c80"
    sha256 cellar: :any,                 x86_64_linux:  "a2da31fe8ab127663bdf75dbbf1200689188f832b9206b5758b40cb8e55945c9"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    revision = build.head? ? version.commit : version

    chdir "web" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
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
