class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "c380a3db83142791b6408132aa60c0226e3f67c84d9e7403e5ad5987901f3adf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95170088deb94fe7a3aedefe7e1f2018d7d09c9168a148f6f4e00daf80aa7b0f"
    sha256 cellar: :any,                 arm64_sequoia: "6cc876f034603c29d2088eaf09f9b39f65d1d3c4eb68d1ba4e7afecaeabc6526"
    sha256 cellar: :any,                 arm64_sonoma:  "7c7360839aef8a4c403533dfaad7d05a3450b1c7c54550428c34a83235f35fc7"
    sha256 cellar: :any,                 sonoma:        "b8cd67e9e59557bea93f9d2d119e585f185c05481ba1debbf3a94a2f1c0cb376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99b52ccfe05e6faa4247fa7acf67a5ef30b7cd01b6838d83742931dabeb4bece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ca81471ef75b0f160b1277cb805cdfb31e3ae728176a90f0ec61d4cbca9651c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utils/linkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
