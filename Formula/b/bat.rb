class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "ccf3e2b9374792f88797a28ce82451faeae0136037cb8c8b56ba0a6c1a94fd69"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/bat.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c49743f75958c8333a3ef923906045bca3cfb890659b87b3d38f1ab9ffa0496"
    sha256 cellar: :any,                 arm64_sequoia: "b07dd7fec6a90bdb42c73b5dc4ee330570610810c8cd397e3bd4171a22aaef14"
    sha256 cellar: :any,                 arm64_sonoma:  "fab51c86bad02391ff22d8b6fa8225b2ee5588236cffd1c13fa882340d9403a2"
    sha256 cellar: :any,                 sonoma:        "4b147697e73d74adf80ef3e3b1bc6c5b3e09538f16d66ee783a5d86d5acf1f7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1eac312a8a8e8c7c1357cfcd2facd210de2872cf376083f370ee1977d09f1cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8694f4ab8f7dde1dbb026624d83410efb4788ff10fcc39f508d46f4a3f65d44"
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
