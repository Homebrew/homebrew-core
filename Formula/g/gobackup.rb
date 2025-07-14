class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v2.15.3.tar.gz"
  sha256 "5ffb9daf0f0698c1f3020fa28cbfc2a4e100922db091a345602dd464f04b9589"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf6001bf9cb50409b7e53664aa70a2e50014c8d0b03683e339d26e8dc59c9052"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf6001bf9cb50409b7e53664aa70a2e50014c8d0b03683e339d26e8dc59c9052"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf6001bf9cb50409b7e53664aa70a2e50014c8d0b03683e339d26e8dc59c9052"
    sha256 cellar: :any_skip_relocation, sonoma:        "99608d3b6097ae8ffc97047150ae2fe29945be524fb7f02948c3852868d62b90"
    sha256 cellar: :any_skip_relocation, ventura:       "99608d3b6097ae8ffc97047150ae2fe29945be524fb7f02948c3852868d62b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "518c737e3d8244496cfdebe3f99aca70a89a9c23e678a809c02364abe79ef8b5"
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
