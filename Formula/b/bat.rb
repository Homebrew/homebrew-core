class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "4474de87e084953eefc1120cf905a79f72bbbf85091e30cf37c9214eafcaa9c9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/bat.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d209bb9f1f7eab77b65f9b5573007ce52f39fb90b379ffefeffc2181119991aa"
    sha256 cellar: :any,                 arm64_sequoia: "072537d409b056879cb735bcbc0454562b8bae732fbbfac9242afea736410f88"
    sha256 cellar: :any,                 arm64_sonoma:  "9492e6fd0b1ee200e279476da087bf1cb6b2202c5e4c2507336c583b836c5049"
    sha256 cellar: :any,                 sonoma:        "033b483e2d1b96c314365048f59a80a83c1827a82bcad99d7b7bc5ef90aa0f77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0211b0cbe32b5b14b76a02a1a15f47c96f677c35102739a3789fb376183b5e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d5a088fbd751c14317ee725a3b9751b835bf0a5ecbd4cfa7671ef90ce8ca922"
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
