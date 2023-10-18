class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://github.com/ginuerzh/gost"
  license "MIT"
  revision 1
  head "https://github.com/ginuerzh/gost.git", branch: "master"

  stable do
    url "https://github.com/ginuerzh/gost/archive/v2.11.5.tar.gz"
    sha256 "dab48b785f4d2df6c2f5619a4b9a2ac6e8b708f667a4d89c7d08df67ad7c5ca7"

    # go1.20 build patch, remove in next release
    patch do
      url "https://github.com/ginuerzh/gost/commit/0f7376b.patch?full_index=1"
      sha256 "091eceef591810a383b1082ba2677503f9cb39a971a8098ebaecd3cd02dd18db"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3333b5b518c55f24c532d6cbcf44dad08f72415b3371c65e59d7e6ad2c7c7b6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b880bb2bace71fb50f816374dd623ad62e893e7abd06101ba88b01f026ba9110"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b880bb2bace71fb50f816374dd623ad62e893e7abd06101ba88b01f026ba9110"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b880bb2bace71fb50f816374dd623ad62e893e7abd06101ba88b01f026ba9110"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f8b42a119ce3827df9b3ec1e9a7e9e2fc00ebff4c2c60745aa7d77289241950"
    sha256 cellar: :any_skip_relocation, ventura:        "77320157771741abee963d6a3e1745a80702745c896ddd83b82cbcf6d46d4e8e"
    sha256 cellar: :any_skip_relocation, monterey:       "77320157771741abee963d6a3e1745a80702745c896ddd83b82cbcf6d46d4e8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "77320157771741abee963d6a3e1745a80702745c896ddd83b82cbcf6d46d4e8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de1f718516d68a836440a2ad09bc48ec150935de28084726bab8e159c2c48860"
  end

  depends_on "go@1.20" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gost"
    prefix.install "README_en.md"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    fork do
      exec "#{bin}/gost -L #{bind_address}"
    end
    sleep 2
    output = shell_output("curl -I -x #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match %r{Proxy-Agent: gost/#{version}}i, output
    assert_match(/Server: GitHub.com/i, output)
  end
end
