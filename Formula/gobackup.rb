class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/v1.5.0.tar.gz"
  sha256 "7b25f38251df7c686b87f1367f68d9fac08d9b6d3aee6ee890878402a397f53a"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efedfb943c77787c82f986b5a4500ebd34aecce85931545dc3c6387ea67c51d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32d58e00d5644783cbd51eefa3e78827a5c150f7537d05e0a9b3b0888ed69f8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e81d8bbe131833b89cce3440402d354c215dea8e25cfa915e9c02c16fd36c45"
    sha256 cellar: :any_skip_relocation, ventura:        "2b19cd2585f5a2705bd72c2cec611b0fbc859acff81c28f8d9e07beb038cf660"
    sha256 cellar: :any_skip_relocation, monterey:       "d1d961556af585afc0506e377b5d2f13367616d19da91e62f1f6c9d67d5f03ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "691c50fc0e2b698f517f9cbc872fff59b8debadd076c31544d74f94768771ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38698124887a562085d49c27349cd29a467cb19923c0d13e08fb7c9a561c0975"
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
