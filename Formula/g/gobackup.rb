class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "3d2b74765f95db37837e24832fd95bd2025fa72cc55fa78b015bb9af08c0f540"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27d10719f838d2f52d79e79a24c8203a57c15327c06b9aecb64d0f52c7d7a571"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55df6861392bcf55a66fcaafcf8094b36a07f9cee33bfe21003a3ba916712bf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50bff4a145b547497418db473012d413e9cb1cb4587f24861953cab57b3ea655"
    sha256 cellar: :any_skip_relocation, sonoma:         "553bdd02eb66567fc4e24c14e318336c7cd34e84c743f5f2b96d167a736268e3"
    sha256 cellar: :any_skip_relocation, ventura:        "2d0e3c081ec3ef429314dc26bf0a0cbfa83efdad276fc8db3f122a5e0ad6a17a"
    sha256 cellar: :any_skip_relocation, monterey:       "012c87946939d7275f390cd933fcc3c853859e6445e335829b3ddbe0e114df5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aed9700ad0c89d56e6e8e44ff0f6c5b91b62b2a4dfa1f75bdc3335e339164c1e"
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
