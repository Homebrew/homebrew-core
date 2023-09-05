class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.18.tar.gz"
  sha256 "197c8311d2e8b9bfb922b3d1fd7d7eb58951f5076296b2c5a20eca49092c98e5"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "772f1cd575528a69158658bbd2f220c6b0f0a88969c4f29fe8f8dcd118b6037b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5fce6f26c0a77ab2ff78e414b43bb7fdb68f8226bfd7f100479b85467fa881e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fad4a4bdaf9ce5c91801e863f275508332d5480c9e5fb475025a2d2d765b638"
    sha256 cellar: :any_skip_relocation, ventura:        "e5e4527bacd3e8eec3e9471b6a76529798406e0fa8011574feef277f43f6c9fe"
    sha256 cellar: :any_skip_relocation, monterey:       "e56ea99dd1f5a0d7f2f40989dca02fd024935b62c298375a91c627ad37c7f038"
    sha256 cellar: :any_skip_relocation, big_sur:        "d64fd11f303700f2a9adb001eb83ff8522e8ed3a5d326b4744daf22a86c3862c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1edcd191d8682c943d0ac6277c638a41f5792036fc092c277805a75e2d6d773b"
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
