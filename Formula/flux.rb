class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.124.0",
      revision: "e9849ceac023cc8015ced3ad0e8e11f7775bee6b"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "661b38233601ba5afe785729b56deb00de45ac03d8d523be727ef2a18cf75975"
    sha256 cellar: :any,                 big_sur:       "b79be036c6bfc53b08574a4f249899bd170cf1e817f43aeb5eed677626323486"
    sha256 cellar: :any,                 catalina:      "ff259440a60ca5c47ce97fc5ae48f0f6d5fd33a829b32605cb7594948697f803"
    sha256 cellar: :any,                 mojave:        "db88621e5d220554a13a97c94972116b7050bd62bec339483ab3e859562529e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77ed3bdd08c02bc7fe8fd19f744979c86e03856c18744885368916cf09fa26c9"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "make", "build"
    system "go", "build", "./cmd/flux"
    bin.install %w[flux]
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a,so}"]
  end

  test do
    assert_equal "8\n", shell_output("flux execute \"5.0 + 3.0\"")
  end
end
