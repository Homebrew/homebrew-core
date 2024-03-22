class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.194.5",
      revision: "505186bac3c68b15ecb156492310e805445cfc1f"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ab99961114255dedb9710008c203ae67b0e1a6b1c46b707e88179a6ed722737"
    sha256 cellar: :any,                 arm64_ventura:  "01aadf549d5bf852a77de28d7e527c4c096c92b5ae87714eac638de58d68510f"
    sha256 cellar: :any,                 arm64_monterey: "e76e6b49e4216ce3385a80db98fd70b26ee2f9b8f143324360208918ca17fb3f"
    sha256 cellar: :any,                 sonoma:         "95367aa090a5d93594423b46ad4f804e20d7554d14364c3df369d7da2257128b"
    sha256 cellar: :any,                 ventura:        "1443bc67895f4e935ff18e28b8a448f4ff7905a569ee34e0cc0d821d59a7a197"
    sha256 cellar: :any,                 monterey:       "46f07198928e32d97331fd0a7c9c3421225fe282ed32f63afb7ca0e50aa52024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c274c4e2bcc26cd0317d68718e62e0f68d78af1f44746eaef59d25dcdf5c15cb"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.12.tar.gz"
    sha256 "23b2ed6a2f04d42906f5a8c28c8d681d03d47a1c32435b5df008adac5b935f1a"

    livecheck do
      url "https://raw.githubusercontent.com/influxdata/flux/v#{LATEST_VERSION}/go.mod"
      regex(/pkg-config\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  def install
    # Set up the influxdata pkg-config wrapper to enable just-in-time compilation & linking
    # of the Rust components in the server.
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args(output: buildpath/"bootstrap/pkg-config")
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    system "make", "build"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flux"
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a,so}"]
  end

  test do
    (testpath/"test.flux").write <<~EOS
      1.0   + 2.0
    EOS
    system bin/"flux", "fmt", "--write-result-to-source", testpath/"test.flux"
    assert_equal "1.0 + 2.0\n", (testpath/"test.flux").read
  end
end
