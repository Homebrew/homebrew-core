class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/1.5.0.tar.gz"
  sha256 "469cca44022d9339fad246fd417b22703258164fd1cdbe040476a1c127791184"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  depends_on "python@3.10" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "openssl@1.1"
    depends_on "pkg-config" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "packages/hurl")
    system "cargo", "install", *std_cargo_args(path: "packages/hurlfmt")

    (buildpath/"hurl.1").write Utils.safe_popen_read("python3", "ci/gen_manpage.py", "docs/hurl.md")
    (buildpath/"hurlfmt.1").write Utils.safe_popen_read("python3", "ci/gen_manpage.py", "docs/hurlfmt.md")
    man1.install "hurl.1"
    man1.install "hurlfmt.1"
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
