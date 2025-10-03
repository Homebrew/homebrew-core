class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https://opensource.axo.dev/cargo-dist/"
  url "https://github.com/axodotdev/cargo-dist/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "7104aa2c1eb94e9090b6f9bc915d8a3cd5c3ef05bddabd9063a6b508c24f3288"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/axodotdev/cargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8793bcfbcb67492861794d2219ad9b0ef68bca8d8d745680cc478c8e2a9ceb5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c971eb5fa6fa3f0f556b003eb9a4966ba4ecd828967816148a552f835836f22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92666c0fb9d68e2544aa3b380a6380c5afc11b36b333adf34cf1f4da0fa2e235"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60f829f71f65736ad92132ba9c2cb007294012dc577904f25c97bbd66d7aa4a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "25f59a04511d17a90146d43e28f2c970e9399dc3ea916ddbbbec64a9eed5d1a4"
    sha256 cellar: :any_skip_relocation, ventura:       "20621484140286fbcd75706666df98f66cc86e4a83d3238e0c2a2262eb198a08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9945da0f56123aa317b3a83e70e531dfbb168ca0b22a660a055e0c060e60223b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9951fe35f80fb827cbe2b9a03599da4360f24e00b34aaf3771f8a7b780735702"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  conflicts_with "nmh", because: "both install `dist` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-dist")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/dist --version")

    system "cargo", "new", "--bin", "test_project"
    cd "test_project" do
      output = shell_output("#{bin}/dist init 2>&1", 255)
      assert_match "added [profile.dist] to your workspace Cargo.toml", output

      output = shell_output("#{bin}/dist plan 2>&1", 255)
      assert_match "You specified --artifacts, disabling host mode, but specified no targets to build", output
    end
  end
end
