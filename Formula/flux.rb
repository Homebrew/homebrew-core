class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.127.3",
      revision: "1836a695e66e359fe826d7af2a565e0a2b4bc66c"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dae4c995f4a375a0317c37bcb9e4d88eecdb6f70aea03f4d0e3c04f6793a2c1d"
    sha256 cellar: :any,                 big_sur:       "c784512992ff5cfdd92c2ae60c5e7785a5372596d5db1c86b6615603faccf979"
    sha256 cellar: :any,                 catalina:      "dae309d22f837dc8d97e0a0fab2dc6ef4cae007aebbf505c34975041e445e312"
    sha256 cellar: :any,                 mojave:        "f5b9efc0067c6580a7c6c482af61a6f63f994a0bbfbc8c3a92936a7377be4634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9a42e826fd5b22b65afda5f8f0a21d19729985249f1f75dd9fe897cf5a56226"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.8.tar.gz"
    sha256 "9d3f3bbcac7c787f6e8846e70172d06bd4d7394b4bcd0b8572fe2f1d03edc11b"
  end

  def install
    # Set up the influxdata pkg-config wrapper to enable just-in-time compilation & linking
    # of the Rust components in the server.
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath/"bootstrap/pkg-config"
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    system "make", "build"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flux"
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a,so}"]
  end

  test do
    assert_equal "8\n", shell_output(bin/"flux execute \"5.0 + 3.0\"")
  end
end
