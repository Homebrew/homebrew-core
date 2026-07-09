class CargoSort < Formula
  desc "Tool to check that your Cargo.toml dependencies are sorted alphabetically"
  homepage "https://github.com/devinr528/cargo-sort"
  url "https://github.com/DevinR528/cargo-sort/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "89c1727bed54379ed112aa6ade693abd86beeeb106c6d043520d6b210b3ff685"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/devinr528/cargo-sort.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df861e29826b8ee2bf78fe393e94faec334fb4a00fce0a758ab06526c9ff467a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c772b46cbb769968e9ca5288b549dba3bd878df8a296dbf7090a5ffa6dfbbaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db9c4885731925a77eb80b6c07968f965f4e239245c29c2dd5a0c69f19d1ab53"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9a094f98f54b4cc8549383c1f12a011b0cbbd70a24efcc507d3fd374ea63ab6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f2c5e9e4aad86ba0486d8e63770aa013de9e47296ec093a2a12d4fe4f3a3f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8118e20d05e6fb779da46488fbed176def155a64fb74d4859ad936f97d1ae459"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    # Fix version string, should remove in next release
    inreplace "Cargo.toml", "version = \"2.1.3\"", "version = \"#{version}\""

    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/cargo-sort --version")

    mkdir "brewtest" do
      (testpath/"brewtest/Cargo.toml").write <<~TOML
        [package]
        name = "test"
        version = "0.1.0"
        edition = "2018"

        [dependencies]
        c = "0.7.0"
        a = "0.5.0"
        b = "0.6.0"
      TOML

      output = shell_output("#{bin}/cargo-sort --check 2>&1", 1)
      assert_match "Dependencies for brewtest are not sorted", output
    end
  end
end
