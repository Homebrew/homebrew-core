class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "82b2d07792010a8cdf7b5bcfaf10094de549a442c451d768d71fc8485aadb0e1"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75c6dfeb6652be15621362c1aceae1535df5b6e6f80f129c08ddf2e904468a7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75c6dfeb6652be15621362c1aceae1535df5b6e6f80f129c08ddf2e904468a7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75c6dfeb6652be15621362c1aceae1535df5b6e6f80f129c08ddf2e904468a7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cadbe18079d12d159b79e3a4683fd46e7535f65d584275c22215aa2d71a4fbd5"
    sha256 cellar: :any_skip_relocation, ventura:       "cadbe18079d12d159b79e3a4683fd46e7535f65d584275c22215aa2d71a4fbd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beec32e1efe83561898c7cf47ff9e19cd022f8cb7600b89458397cb1720a7200"
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
