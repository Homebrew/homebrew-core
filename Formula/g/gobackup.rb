class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "2e0c5df030c67273445fd89c27f1aa794716393c0e96c22b995f6cebfb16e766"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64f41bb41bc575fedf4844faa299b4f96f6aa0cde962666e66f16075d2181b43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d1cdef712b773ef9bc6bad55e444a5a451df21c8ad15e48e331cc5594f79aaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4287328045e926dcf7a395f3e0a55544e748d716102429514ac741287493d741"
    sha256 cellar: :any_skip_relocation, sonoma:         "96b233f46873af37e28d74c9453fff0c1c2ae0034e4cb3d6a7b335674eca77b1"
    sha256 cellar: :any_skip_relocation, ventura:        "6a1ce419d5034cc94ef81c9746bc753e27e5529536c8984f1cb90b99ffe8f94f"
    sha256 cellar: :any_skip_relocation, monterey:       "44005430c259b922cad498e1a61d011e487c1b0ef4234bcb8d78861e44db103b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0cc8c4cfc977f7bbf31f4fe2a4304b0f5d8865c14e003b64abda861b0987eb6"
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
