class CargoSort < Formula
  desc "Tool to check that your Cargo.toml dependencies are sorted alphabetically"
  homepage "https://github.com/devinr528/cargo-sort"
  url "https://github.com/DevinR528/cargo-sort/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "2add0719d3309e868e8e305ce33bfbbd59554853e1cef2866af6745b750a689a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/devinr528/cargo-sort.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f705b9d2acf22f9d3a938c0a6fcfd91542216c3c5708ca9b925b6306335cad00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50433c453c2b06805d430060ab93af25bf7c357a6561d7ecdb5f20b005b5ee2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cce8f602feae89f057f651943a59cb19054ac9dfd795b55ec036c83c0e6277e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d07ea46096df39b7e931785beff09de82825d8312599c62d2768c9809b53e70"
    sha256 cellar: :any_skip_relocation, ventura:       "8f7d7d7098162924d7b52634dcc6b8e79c488340a440a414884ccfd61dac769c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "854534758b149b5c0d7258e12ce22ed0dc04edfa3f5c2cd306c93d10288562f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4dca60b315658ddd7aecbddae66691dc439fcdf620325e5cb367df4c754f4a1"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
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
