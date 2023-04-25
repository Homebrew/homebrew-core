class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/v2.0.1.tar.gz"
  sha256 "358193fc78e1e1f4beb73709e20d4cdd6ca33d542a05c342bb02614c9125b59a"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19c9869f5bb0b3047cdbe73ac40a3f1fa47e30c837524e6521dd16c9be366941"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c06175a1068477fa9d6d44afdc00c812fc7166b1d2b72b2ffe0c4155aafcbe44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a385cdb432a2d210e87d58a776a1c9c10bbdba6edfba4f4f5391bfc85dbe1c50"
    sha256 cellar: :any_skip_relocation, ventura:        "d7318d238799b588b734a8350ca822806873cc0a039674235fa3b7499bb47dca"
    sha256 cellar: :any_skip_relocation, monterey:       "6a43138c6b1c44a85d95d21a46791230bf4afaa91f1832b03ea9e4d87949a737"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dd097dc5be6a8e45896bce7c0962f38805b3eef15eb57565296dfc93746862e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4051013268c7c0c7ff0357449f5b9220647ca84e2ff7276fde648cb347e7c76a"
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
