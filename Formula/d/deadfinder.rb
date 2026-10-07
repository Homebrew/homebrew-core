class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://deadfinder.hahwul.com"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/2.1.0.tar.gz"
  sha256 "ae2364f33c1b94f9d2183162b6dd42ae33a68dbda970a1e67c9080ee1681c7d9"
  license "MIT"
  revision 1
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c91ccce9815476de101ed1bf76a34d24fbe65989f78309cb1b69deb9ab5a2298"
    sha256 cellar: :any, arm64_tahoe:       "fd9328d00e1514b764cf949fc27f6706079dba78dcfa98fff25a85af673fd5a7"
    sha256 cellar: :any, arm64_sequoia:     "6b79fc25e42087dbc7f565cd0ae452e74838fb4ebeecd5fd8e7f7ffadc87d683"
    sha256 cellar: :any, arm64_linux:       "2610405c5b68214dd848316f6d800eb36c2cf8e07638aca0ba195f170bbad231"
    sha256 cellar: :any, x86_64_linux:      "ee2fc74f8724a7c3fa9f5d5d40fd1242e2698cbff00b32676cd542cd55e7ae0c"
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
