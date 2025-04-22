class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/sharkdp/bat.git", branch: "master"

  stable do
    url "https://github.com/sharkdp/bat/archive/refs/tags/v0.25.0.tar.gz"
    sha256 "4433403785ebb61d1e5d4940a8196d020019ce11a6f7d4553ea1d324331d8924"

    # git2 bump to use libgit2 1.9, upstream pr ref, https://github.com/sharkdp/bat/pull/3169
    patch do
      url "https://github.com/sharkdp/bat/commit/01680e444ba4273b17d2d6d85a19f7a5e7046820.patch?full_index=1"
      sha256 "ad450b12f6a4a8332bf1e249a239518c7edfe94ccc6abbbeb705cf22620c5619"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "63e99dea5bc85d0e9c3c76c41c7324933d05b791c86cbdb47bf173bbb4f25afd"
    sha256 cellar: :any,                 arm64_sonoma:  "53705be5ee2484a8e2254437e0197b763a27b4e3a88e2c9aa7f43c739ecc48c6"
    sha256 cellar: :any,                 arm64_ventura: "a058d53d4156ae1ea72b9d153533f253b57fcbd273d704e7f9f867c0e6b05562"
    sha256 cellar: :any,                 sonoma:        "c9dc4cc4d679e32223eec006c4b52c46fcee17e67fdb762dd494f839ba8a199e"
    sha256 cellar: :any,                 ventura:       "0ed6d0e85d9af4020f4eb0f41efc2e8f1e7ca5d8deb2bfe82cb8d4a24591cdca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0a32aac15c2338597b6faf190ea1ffa7e3f77a85470e9612c3da9cb9b85b7d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68f6c503b8895e4390935142c771030aca2d70b7fb3fc72449df664e05af1680"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "oniguruma"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args

    assets = buildpath.glob("target/release/build/bat-*/out/assets").first
    man1.install assets/"manual/bat.1"
    generate_completions_from_executable(bin/"bat", "--completion")
  end

  test do
    require "utils/linkage"

    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["oniguruma"].opt_lib/shared_library("libonig"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"bat", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
