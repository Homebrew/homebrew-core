class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://github.com/ginuerzh/gost"
  license "MIT"
  revision 1
  head "https://github.com/ginuerzh/gost.git", branch: "master"

  stable do
    url "https://github.com/ginuerzh/gost/archive/refs/tags/v2.11.5.tar.gz"
    sha256 "dab48b785f4d2df6c2f5619a4b9a2ac6e8b708f667a4d89c7d08df67ad7c5ca7"

    # go1.20 build patch, remove in next release
    patch do
      url "https://github.com/ginuerzh/gost/commit/0f7376b.patch?full_index=1"
      sha256 "091eceef591810a383b1082ba2677503f9cb39a971a8098ebaecd3cd02dd18db"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a27e7e6720095678916b47236b60ba280773f57d3168450c73a81b8857c8815c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a27e7e6720095678916b47236b60ba280773f57d3168450c73a81b8857c8815c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a27e7e6720095678916b47236b60ba280773f57d3168450c73a81b8857c8815c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7a3db5ee313e576ab5b8ec6b3353153e0161c33396ed8355a49a094908fd5e1"
    sha256 cellar: :any_skip_relocation, ventura:        "d7a3db5ee313e576ab5b8ec6b3353153e0161c33396ed8355a49a094908fd5e1"
    sha256 cellar: :any_skip_relocation, monterey:       "d7a3db5ee313e576ab5b8ec6b3353153e0161c33396ed8355a49a094908fd5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccbbcfddd4e05137303c86f5d25bbbf8ecccd093a72c6af80cd79b800bdf5d4b"
  end

  # no release to support go1.20, https://github.com/ginuerzh/gost/issues/1012
  # also no actions on go1.21 build support PR, https://github.com/ginuerzh/gost/pull/983
  deprecate! date: "2024-02-14", because: :unmaintained

  depends_on "go@1.20" => :build

  conflicts_with "vulsio-gost", because: "both install `gost` binaries"

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
