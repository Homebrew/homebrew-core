class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/v1.6.3.tar.gz"
  sha256 "6d0c41b8604542c61e5239498873ef1bdfbfe99617322ab5fde5fa96556d1207"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcaee10ac9fc9d626d86f4673e8ed149eeece966a144d46b5b961f6cda0c81aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e65a97e9046b7936ea910a8f2e64de15d72ac2adfe7af1c5fbf6e8029e7dff7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd9d00b7d669ec95ffcd5174746946577eb30954b65ea827cd84c0b05ab922ba"
    sha256 cellar: :any_skip_relocation, ventura:        "651aeb1f7a18738b9cfad6aca9e26b95d2dc79eee1c25b2505d42d903e37331d"
    sha256 cellar: :any_skip_relocation, monterey:       "8cf2152f8a4cb448f275afa9f57bc875db8663fce9c4fdce049883460a35da02"
    sha256 cellar: :any_skip_relocation, big_sur:        "38f08bcbe31822436ddf0c450ff5811e4df6d8c5edcfee302c770b20524d1254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf3b914732752fb1aa39f4e889f636bd8ef48dadd39ea1485d02ce7c8d0d5d75"
  end

  depends_on "go" => :build

  def install
    revision = build.head? ? version.commit : version

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
