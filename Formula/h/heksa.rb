class Heksa < Formula
  desc "CLI hex dumper with colors"
  homepage "https://github.com/raspi/heksa"
  url "https://github.com/raspi/heksa.git",
      tag:      "v1.14.0",
      revision: "045ea335825556c856b2f4dee606ae91c61afe7d"
  license "Apache-2.0"
  head "https://github.com/raspi/heksa.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1268c82b2fd88b4dd497010c2d7b897ea66d2a66d68e74987f64a3f5e2d21ddb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ba04dda9e2366f4af82dc315932e46e298779ffd0a4a1e5bbf37f531b2c9b102"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2e5970a9ac9da77a4e75733b5afe87fdba4704007b938e35855714c204ab9d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89b15d07d2e29580a0ee9b2f71fc60f36b71e2e7bfb8c460e24fcc5f005bd9e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4cab211255c75ce7044df346f1b85d3a548c2a760be570a10fcc970a3aec5fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de0c36cdc7215c90ea71792580f298717eeffc2b8d6e7a556cd55e4a9c6fd43e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c646a1b7289f4b96e1172ff6bec29fac49fe66a414f93886182f1d67399d37a8"
    sha256 cellar: :any_skip_relocation, ventura:        "3bff648f15075466f5e8ddfa77e7092428b6d294091c8f95dabf53e6688a97f6"
    sha256 cellar: :any_skip_relocation, monterey:       "2c40667b5945ee8ce31d17eef4edb72b05d2238bf6a19210885d29471218eb1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f58fd184f70cb5601d2da5737aff2add348d98eeb7724460dbdbebef04bd9ea6"
    sha256 cellar: :any_skip_relocation, catalina:       "98f162aca970fdb91350424f8f4fcf94348b07d598a32355c6e2dfda57b31150"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "81ddc9393c38b0f1fdd8543e44b74bf011c31e1bd71b68ca414b436aeaebbc0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c2fa3a47b5d6a492a5bd6b3c881b19714c459adaf3103d1313e9cf9213386a"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/heksa"
  end

  test do
    require "pty"

    PTY.spawn("#{bin}/heksa -l 16 -f asc -o no #{test_fixtures("test.png")}") do |r, _w, pid|
      output = r.readline.gsub(/\e\[([;\d]+)?m/, "")
      assert_match(/^.PNG/, output)
    ensure
      Process.wait pid
    end
  end
end
