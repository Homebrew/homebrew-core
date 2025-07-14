class Mlc < Formula
  desc "Check for broken links in markup files"
  homepage "https://github.com/becheran/mlc"
  url "https://github.com/becheran/mlc/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "1558d504da177e263d9fe61457745e1c0cacfbd58deaf862dad668be7b204300"
  license "MIT"
  head "https://github.com/becheran/mlc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27722df9d720b8cd78506aa76148449531cf5767108699b795a1b5bfe7eaf443"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7751a88415cd6bc66cc1a20c9454556fda1fc3d9b625a847291513e2653ed676"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64bf4f630ac577c11b7b14dde5cdb8471a5d3ff87ed3ae8700ae5c79178e159c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6e4072ff25800b2397e962a3c5b3b837b9cf883ae9d2223cb04082216a6764d"
    sha256 cellar: :any_skip_relocation, ventura:       "0ccb8ab45d7a34a78fc7d1e8f8c61bdcd47edf691e48db0d802ef64dcadfeb69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df4de4041118ca03f177d9667d80742aa1662967dfe9131677a2cb1a09d28f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f69e9fb707a984b0714a3904aef29435f6aed854341217d23d560f624c0164a6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Explicitly set linker to avoid Cargo defaulting to
    # incorrect or outdated linker (e.g. x86_64-apple-darwin14-clang)
    ENV["RUSTFLAGS"] = "-C linker=#{ENV.cc}"

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mlc --version")

    (testpath/"test.md").write <<~MARKDOWN
      This link is valid: [test2](test2.md)
    MARKDOWN

    (testpath/"test2.md").write <<~MARKDOWN
      This link is not valid: [test3](test3.md)
    MARKDOWN

    assert_match(/OK\s+1\nSkipped\s+0\nWarnings\s+0\nErrors\s+0/, shell_output("#{bin}/mlc #{testpath}/test.md"))
    assert_match(/OK\s+1\nSkipped\s+0\nWarnings\s+0\nErrors\s+1/, shell_output("#{bin}/mlc .", 1))
  end
end
