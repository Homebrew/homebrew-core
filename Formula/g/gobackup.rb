class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "9c52b732c7d20e599f833d4093553016ae746f2ddabcd204e7369ac62c7076f5"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea6e0eeb9f731697437577314a8f0a45f736b337ccffca3cfe58bf89b9479cf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea6e0eeb9f731697437577314a8f0a45f736b337ccffca3cfe58bf89b9479cf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea6e0eeb9f731697437577314a8f0a45f736b337ccffca3cfe58bf89b9479cf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bf90702034c37229027ec5b0955dd9e62252dc04c57828587e4f72124902eb8"
    sha256 cellar: :any_skip_relocation, ventura:       "2bf90702034c37229027ec5b0955dd9e62252dc04c57828587e4f72124902eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b7393863eaf6af1c6571ec1412ff063cee6ed66f306b01b4cdacbfba47fd12a"
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
