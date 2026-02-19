class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "6708920cfb35b48886496c74abf6225b0c4865ba0c1a24901e5545d7f70e1683"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ce1373eeccfcc8253b9f4514fe17ec50d8bd404ad85e7381e50d5e4bc546239"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ce1373eeccfcc8253b9f4514fe17ec50d8bd404ad85e7381e50d5e4bc546239"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ce1373eeccfcc8253b9f4514fe17ec50d8bd404ad85e7381e50d5e4bc546239"
    sha256 cellar: :any_skip_relocation, sonoma:        "458e1a8c55aaf7db96db9d75a6707bb56288f84dd40e8ba58fd7b0bb61a0feac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1120fc0be81734d225cef6711549f08b67f4cc413c3fc581123f3dd5eabf46f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbff8c521a35a565dc1796ef5bcc3dd20836da924dda2e2ed0f3b4abf4f40d7d"
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
