class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "e7da57c30a7bf3c731bbc95d0be29ef14bab9e26ef8f0871df8ccaee241678dc"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/sharkdp/bat.git", branch: "master"

  bottle do
    manifest_sha256 "24acef5483a3bf8333ec5f21ec37028d37c1dc3a3985952b9942dd29366d9a6f"
    sha256 cellar: :any, arm64_golden_gate: "b9e2ba9ad4eb0b63c21c56ffeb7cb28806c7beb14c992d5148de42cc674f783a"
    sha256 cellar: :any, arm64_tahoe:       "a830de290e2e0b8cb730ca0a249394f53fb0429dbd408377e7ea387c6415a93f"
    sha256 cellar: :any, arm64_sequoia:     "3e14bff0d40a387aacf1bd6fc470e5470dc08ca0a2d2f7e1957e2ff4e6969c92"
    sha256 cellar: :any, arm64_linux:       "6e10f6de125adfda98f7f03a3f32bde7f7ffaef901b19993b75ec1330c28f191"
    sha256 cellar: :any, x86_64_linux:      "f3c86b6b70605347bb3927f5b6037e253de5a130f3a3ba5b877eac68fb7933fe"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    # Generate assets outside Cargo's version-dependent build directories.
    ENV["BAT_ASSETS_GEN_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args

    man1.install buildpath/"assets/manual/bat.1"
    generate_completions_from_executable(bin/"bat", "--completion")
  end

  test do
    require "utils/linkage"

    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output

    library = formula_opt_lib("oniguruma")/shared_library("libonig")
    assert Utils.binary_linked_to_library?(bin/"bat", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
