class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.22.tar.gz"
  sha256 "0977e4b8ae854278194b15f3dc6472d217b9619a024d03f60e95393352212385"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "623d8a0313916bb2c65d9cf19ae8dc84f7e0c275c17fbddb5a7d59a458fe88ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "584ecaa377f8a94f5a349901ca9202866c8fd9dc224af1e37eac040501336da4"
    sha256 cellar: :any_skip_relocation, monterey:       "dd045c9cccbeede2fb2567c6b92c6ad226c29e25f4d53d1afa538a07ac2a241b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5aede4fbe90c7eaab0eb5301c1846ab35b170892594db3f43bef246c6220c015"
    sha256 cellar: :any_skip_relocation, catalina:       "e837d6b9412ea1431cbf107ad8c04416d53640968da5bbd42609ed1a665b48e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82ac35fa6e9bf9dcd9d92160a986f45f80f4db2352a8cf70cf8d7d76ca594ac7"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin

    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
