class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/1.7.0.tar.gz"
  sha256 "6f5b01de19a1c3376a714c9636aa8d4497d060826a5656cb94785fb4be3468e5"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32757008a6c9ef3534903f0df53b1866216cb0adb2ecba3aba36a3744b643618"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16383fba0fb749d7b14f61ffdd079bee7932b4c2bdbd32d886e9a2858fc34d0d"
    sha256 cellar: :any_skip_relocation, monterey:       "eb3f5aa56cb32d06c5b2c8fd1bad3ac319b70fc6eae21e5ecf6813693a9c9736"
    sha256 cellar: :any_skip_relocation, big_sur:        "ece4522f6de010f78e92d7783978aac70f3ceaa2fd697effe0643b25e5199870"
    sha256 cellar: :any_skip_relocation, catalina:       "2f99add5ceeecc9816ad4f376c6097553b3d8c738541a3a9d3462cc5dd6eb34a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65a039d31e6cbd088f486badf5eb2cacc288c181bae7b15911125d8c12bb02f7"
  end

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "packages/hurl")
    system "cargo", "install", *std_cargo_args(path: "packages/hurlfmt")

    man1.install "docs/manual/hurl.1"
    man1.install "docs/manual/hurlfmt.1"
  end

  test do
    # Perform a GET request to https://hurl.dev.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.hurl")
    filename.write "GET https://hurl.dev"
    system "#{bin}/hurl", "--color", filename
    system "#{bin}/hurlfmt", "--color", filename
  end
end
