class LanguagetoolRust < Formula
  desc "LanguageTool API in Rust"
  homepage "https://docs.rs/languagetool-rust"
  url "https://github.com/jeertmans/languagetool-rust/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "db1da3e821976c2e5e85c26037301dd43fe8baff6bff243c498f74f7c5e57d37"
  license "MIT"
  head "https://github.com/jeertmans/languagetool-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58375defa38ac43d3943c08967a4fab9ac2bec7ffd69d042f02296defb1abbe2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "088c12e33f0960eca09b131d46e8e821947d7d330efdef500f6bf31c1587e295"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "353bb7ad7e99b30e66312284a0ee1b8058479f3892da5a3ee336b80a9d58cf10"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2dcfbb19328a045c4a6bebea59fa674bfcb6d4827938cd4d5ff2b0f6a63c095"
    sha256 cellar: :any_skip_relocation, ventura:       "53961fe44f3a0564943b62dd179df6e2760bc33b7ecef8927cc6d6c20f44b8fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "020bb11bed660cc4710f5eeeda2c37becfd66ef9a69b3d8e8fb25d7750bd463f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c575d0c3dbfe53942702f762527241952714188e2952e05c3a7f08e0273da048"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "full", *std_cargo_args

    generate_completions_from_executable(bin/"ltrs", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ltrs --version")

    system bin/"ltrs", "ping"
    assert_match "\"name\": \"Arabic\"", shell_output("#{bin}/ltrs languages")

    output = shell_output("#{bin}/ltrs check --text \"Some phrase with a smal mistake\"")
    assert_match "error[MORFOLOGIK_RULE_EN_US]: Possible spelling mistake found", output
  end
end
