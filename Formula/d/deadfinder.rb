class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://deadfinder.hahwul.com"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/2.1.0.tar.gz"
  sha256 "ae2364f33c1b94f9d2183162b6dd42ae33a68dbda970a1e67c9080ee1681c7d9"
  license "MIT"
  revision 1
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f14092874a87bac2119594d0648b5650bda38f4e867bb48258e4e6eb3bcaa593"
    sha256 cellar: :any, arm64_tahoe:       "6bb11ef4b2d3756b6ad005cb547e3b9b890151f25696f1249d153ea4bcd5ff44"
    sha256 cellar: :any, arm64_sequoia:     "34a1f7bcc759aa07b2486dcb6bc3412367180c8f57924f12bc4e4b1eb87b02ce"
    sha256 cellar: :any, arm64_linux:       "5a1b427df0f88a764d114a8c288ade0fb42098254d3e309a5ff1eb39b5e799a0"
    sha256 cellar: :any, x86_64_linux:      "a247599a12a2cf6b08d299b9e44bbba99893cb7343036b1a4a107d6b27bdffbb"
  end

  depends_on "crystal" => :build
  depends_on "lexbor" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@4"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def fetch
    system "shards", "install", "--production", "--skip-postinstall"
  end

  def install
    ENV["CRYSTAL_LIBRARY_PATH"] = formula_opt_lib("openssl@3")
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("openssl@3")/"pkgconfig"

    # Use our lexbor as long as compatible with https://github.com/kostya/lexbor
    (buildpath/"lib/lexbor/src/ext/lexbor-c/build").install_symlink formula_opt_lib("lexbor")/"liblexbor_static.a"

    system "shards", "build", *std_shards_args
    bin.install "bin/deadfinder"

    generate_completions_from_executable(bin/"deadfinder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deadfinder version")

    assert_match "Task completed", shell_output("#{bin}/deadfinder url https://brew.sh")
  end
end
