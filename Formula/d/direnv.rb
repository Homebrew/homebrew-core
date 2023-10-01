class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.32.3.tar.gz"
  sha256 "c66f6d1000f28f919c6106b5dcdd0a0e54fb553602c63c60bf59d9bbdf8bd33c"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a8436d33ce6a6d19ec4c177304b46de90c51e5bf8c34b6c59fc87d7ac768759"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8349393ab02680cd46631d870fde9f4f66cb69a12b0c8c57ccc9beb05861e33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd652c6a23b380884b7f8554e1e916cabd5d0503883783b115fb2c30a2e9ee1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30d022f74ec3cd0f14b28f6b498ecaa6067c77802320177e69b57e015fcb8533"
    sha256 cellar: :any_skip_relocation, sonoma:         "55a81cac50200cad48927c64c4bbb29ed7bbc4e080762449b8800482386c9564"
    sha256 cellar: :any_skip_relocation, ventura:        "3dd3db7beae8e876f0945302f5038a1528987b72ff33b16bfe626f4469a7e264"
    sha256 cellar: :any_skip_relocation, monterey:       "d8a2d94c985d3fca8eb1fb7e1ab28b542008995d65e78658f6be0395d6a26608"
    sha256 cellar: :any_skip_relocation, big_sur:        "139d35367a4f9e7a14f3dd8bbaa2e2b7e08c35cdeb6e98990349e9a583d093de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ca33d2cfc8a8af1f4775d823986ec53d8fbfdbd9351914514ad39ee612f8595"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
