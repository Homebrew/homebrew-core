class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.26.tar.gz"
  sha256 "8076e0bc5fd35eedaa21315857c80950a90cc286caf154854ebd19c8318aae51"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe30da0f3b497cf5e1037840bb0a5cb05a2c10c1fb80b0058b1c0bb6beb1f0e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74c74db6075c92321184a17e623d8c621ff3157b14be19ad468e14d409e33840"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f54949dead6010f6ac02f5b8f76d0b635983e37320150ec01ed3b12fb68c2c52"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a22ac4148390b00286458d018fc851c051f5a838c79c9bf9e62f421d39b52cf"
    sha256 cellar: :any_skip_relocation, ventura:        "b45fe612f71e1240ce93083a41cc0e1512f60be6a56cbd5da9dc7660d6d9e13b"
    sha256 cellar: :any_skip_relocation, monterey:       "04b7fd0c855db0cbd949b665ee6abc9cfca496a97654e62d8e8c1ca4fb1fc5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0224e62a79ed467f740165c77eef2a1d42d98fcaaa6b415ec2d43a82a9e0b688"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"conf.yml").write <<~EOS
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    EOS

    output = shell_output("#{bin}/gickup --dryrun 2>&1")
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}/gickup --version")
  end
end
