class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "0f2228e4db10ab8711be41ee44ac8626283dad142b1e79c975decca0c6815c24"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c34a2d82807dd492cb90fae12536cbce325de72f62783f6317e33002330e2a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d185e2d336ba7268139fdb54f67fc1bdec7b68f56d15465d350cef2c49768f7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3b9dee75363d50c8554682d189d021e75c53eae0216e458463f757cc3200b77"
    sha256 cellar: :any_skip_relocation, monterey:       "d9d6da87b3fec017648c4ee5c2a0a50a5517b4ed8d79c5211f9d0d18a2560d69"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fd2747f971cf36e1dde42ccd78839bb437b7347884c865ce44e3a012b646382"
    sha256 cellar: :any_skip_relocation, catalina:       "937e8ff1eab72d7e9ee236a4db81425e337c41b986994f98eaeb92be77abaf2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d78220fe144f37d781382800e187f339927a949aa46dc4f6d47bc240524810c6"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid username or password",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
