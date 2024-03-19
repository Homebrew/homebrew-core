class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://github.com/gobackup/gobackup/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "5783f308cb7d5433e921b9cf7870dc67d9a0217656adf2f66180fa0a1fcbcff5"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa112d542f92a1cad7185048369df6fff633c6cdc4c86a9003cd6312f4c8cbf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3309c6542bff04548f1a7d0e752f72ccce05d614c2d1ec246666db48ebaa5d7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27bb393017ebd5400e913411e60a936a0423e112e7280fb46a5d9656fad8189d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9daf5bfe9e8f0c7407fa4a1f0ffad1a98b65b75a4925bffe7bb6238aad3d0719"
    sha256 cellar: :any_skip_relocation, ventura:        "baab9b681462de8592544e3fed30929258e06cb548b8ea6bf1e07c666c5d749a"
    sha256 cellar: :any_skip_relocation, monterey:       "050d86130939686e4cf695c019048f92ecaf06d22fff446810a3626298c0d782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c918e234f375c9b90ef4406a2e8439caeb1d1540fce57e0e307120a5dfc01c1e"
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
