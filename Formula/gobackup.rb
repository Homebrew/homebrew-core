class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/v2.0.3.tar.gz"
  sha256 "11b2551178770965c50eb52aac7bf5e7d3b9dff55a33aa56de0f7dd331959ba5"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48f1531d9e167eb7cb0c2f6167219a92ed03ffee77e2ae1726d2cffe15fa265a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48f1531d9e167eb7cb0c2f6167219a92ed03ffee77e2ae1726d2cffe15fa265a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48f1531d9e167eb7cb0c2f6167219a92ed03ffee77e2ae1726d2cffe15fa265a"
    sha256 cellar: :any_skip_relocation, ventura:        "a3fb53e80e5d4328d4a9130d59f25d27280a45e11dcf26653ccda83d2241dbce"
    sha256 cellar: :any_skip_relocation, monterey:       "a3fb53e80e5d4328d4a9130d59f25d27280a45e11dcf26653ccda83d2241dbce"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3fb53e80e5d4328d4a9130d59f25d27280a45e11dcf26653ccda83d2241dbce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73ac8d46a828f1141c43571095619fae432b85487b5c057af1bf2bc13043d378"
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
