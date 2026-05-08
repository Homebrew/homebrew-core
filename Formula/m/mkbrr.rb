class Mkbrr < Formula
  desc "Is a tool to create, modify and inspect torrent files. Fast"
  homepage "https://mkbrr.com/introduction"
  url "https://github.com/autobrr/mkbrr/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "3ccce5e227301bc74cf86600ac593a0d2cce2b2b05b271e70fdf8950e079908b"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/mkbrr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7c1b9e63d824ccaa4ecc13f6e32956ea4749d63b19dcefbd7cad3a11cf007a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7c1b9e63d824ccaa4ecc13f6e32956ea4749d63b19dcefbd7cad3a11cf007a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7c1b9e63d824ccaa4ecc13f6e32956ea4749d63b19dcefbd7cad3a11cf007a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d8e05cba844fb42ac38455dbdac3310e296651d47a2a6d42cd040bd598afa93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa1abd05da434a5fc7b54be1d45c9b3cc08692be43d84e27a7f36749d6acff26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8709a080a84f59fa4eb5f8311287112e64afb0428e66ba4d734e50247c24cdb5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.buildTime=#{time.iso8601}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mkbrr version")

    (testpath/"hello.txt").write "Hello, World!"
    system bin/"mkbrr", "create", (testpath/"hello.txt"), "-o", (testpath/"hello.torrent")

    assert_path_exists testpath/"hello.torrent", "Failed to create torrent file"
  end
end
