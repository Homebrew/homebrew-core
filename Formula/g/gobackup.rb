class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/v2.6.0.tar.gz"
  sha256 "79c265bcd8342a713b145052781b55cffd55536244b9ce23ff241769a4b0eb83"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34c45a3fd5149697062ac653d53e865f2e34d4f85c94b48198a1afb2c02d153c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7c558e3d238b0db24d3b2b7f45b9f10538e384216cbca2649146a2431d4a2a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7c558e3d238b0db24d3b2b7f45b9f10538e384216cbca2649146a2431d4a2a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7c558e3d238b0db24d3b2b7f45b9f10538e384216cbca2649146a2431d4a2a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "70e0422d711fedbb563dab0864bbad02bfcb508cb85f5a960ebd5aeda8dd901f"
    sha256 cellar: :any_skip_relocation, ventura:        "e0bc9130100c19c83e1330c806dd5bd68ec4e49ff4ec8b89d5c2956e1ceb4cda"
    sha256 cellar: :any_skip_relocation, monterey:       "e0bc9130100c19c83e1330c806dd5bd68ec4e49ff4ec8b89d5c2956e1ceb4cda"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0bc9130100c19c83e1330c806dd5bd68ec4e49ff4ec8b89d5c2956e1ceb4cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70875c7af6467dfbf3aedbd88390bf34f0d44081a1571c481a7d633238791192"
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
