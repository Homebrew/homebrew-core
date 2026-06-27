class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "81c62b882d2865c37f516fc4eadba1baf3e252a0b9744bcf66544bb763e52373"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e30d1a676a040eacd8468ad691213db08be73374e2256c51e8350854dfb56c84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cfb80bce7f6fd3e467f4fef227478add07d5e7ad8468372f622fb2eb9c448b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0662334ea7093208450f315848c7536ed5a874188f69887fbc1d01e8731bfbde"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4187c2c27fb9c0a8fe30f0c7356715cc9dbbee0eb253d91cf276cac63fed78e"
    sha256 cellar: :any,                 arm64_linux:   "595c4c6b138af1bd0ee925c22bcbe40f6d5072ca0762b25df6827f62dcd18183"
    sha256 cellar: :any,                 x86_64_linux:  "c26795ab5e3c57ecdbe2d891085903befc762fa10cc439f11dcfa4467cb02011"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_LOOKUP_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    node_version = "24.15.0"
    system bin/"proto", "install", "node", node_version
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match node_version, shell_output("#{node} --version")

    (testpath/"test.js").write <<~JS
      console.log('hello');
    JS
    assert_equal "hello", shell_output("#{node} #{testpath}/test.js").chomp
  end
end
