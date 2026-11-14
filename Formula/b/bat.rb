class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "4474de87e084953eefc1120cf905a79f72bbbf85091e30cf37c9214eafcaa9c9"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/sharkdp/bat.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "4f85c0855e391d5622c0dba97474ce7cf617ea43f9bb264e6ce4f2edd682091d"
    sha256 cellar: :any, arm64_tahoe:       "19c6976b3466dadae4cc2538dd9f5795d0b1eb9c65136aa7f58cf1e3852ce7c7"
    sha256 cellar: :any, arm64_sequoia:     "e1acf0a602a2b067552610139abd0957bdb9aec8cb54ad883e0c318331300007"
    sha256 cellar: :any, arm64_linux:       "e35f1a60200c599fba9b777bb06806459bf06b230617efb92979cab02b974ead"
    sha256 cellar: :any, x86_64_linux:      "cbd6b9347f601e48ca2301a28d9d269829b8deb4f2780fb6e640182a51325f2e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "oniguruma"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
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

    [
      formula_opt_lib("libgit2")/shared_library("libgit2"),
      formula_opt_lib("oniguruma")/shared_library("libonig"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"bat", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
