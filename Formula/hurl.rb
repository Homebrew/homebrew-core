class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/2.0.0.tar.gz"
  sha256 "19ba495db8eda29f6611ab277a4ca489d2fc203ba92c0da3d32812a8acf566b1"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7377432551c55d48c27124112d6f398d10534c3705093a315c642b150f28275"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faa952ffaa60ad8dd8711f73ef74a3cd9e6a05920b4aeb80b38e143ba6d4408f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cde81be0dc56aa6558140e0dd1ac2deb4b34f1b398caa9d065f5f34e0ccffe9d"
    sha256 cellar: :any_skip_relocation, ventura:        "606a1e31ce6abb405ba5f402ff5c3f37138140350acf73bba31b5b9673526a9e"
    sha256 cellar: :any_skip_relocation, monterey:       "3a8f03b9ec4794d27422c657feb1714232f88e7094d63068bb0e729ab9824c00"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbd7b43301f355f9f835da3a93d0136692b28b6780204f7eeeb90254b377f11a"
    sha256 cellar: :any_skip_relocation, catalina:       "f3ea203686b9fd65326b60b330d4c15ca7fd4f29c81c22aa9b8dbae9f8e9d14c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "635c3f8afe16034b6fae7a609be540739a3468c1d58fee200addaa994f2bbf01"
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
