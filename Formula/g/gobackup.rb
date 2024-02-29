class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "c44aede0ceb02ddc4a05580837b0f4ebf18e74385d734b5854e308326266c7ea"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3501cb013f8bbdc7ec56350c8cfc0d6b4d3ba6c9d27ff234eca97ddc0c303c6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4da158e167f6c427091c99790efeb3033d105e79173495fd5234e65a1b6732fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d395c5faa13f2d5828339f4c508af45dfe8d5be9a587458907ff7f4b22e07f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "5278e39355270e952b40bb2d54a422eaa237a8bac5549cbb230b7ec9c41203a0"
    sha256 cellar: :any_skip_relocation, ventura:        "f6c5170a976f648800a6523acee4ce53816ed915a6d30fa73ac85a35b1ebace1"
    sha256 cellar: :any_skip_relocation, monterey:       "f2cc16cb614fb5b93db6dfbdd1fa0531852feab8c27d887702f4fe2de631024e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dc389cd807efd6bd35843b3b339935a9679de3d735b57c6a049b88943898b4a"
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
