class LanguagetoolRust < Formula
  desc "LanguageTool API in Rust"
  homepage "https://docs.rs/languagetool-rust"
  url "https://github.com/jeertmans/languagetool-rust/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "8fbd18fd9b6a7e049fec39d9d4ebcc3563ab7779b849ad5aa2df1d737002c30a"
  license "MIT"
  head "https://github.com/jeertmans/languagetool-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47b10bf2de0130d24efd9ea4a32f8dbdd9eb262d307d4367df02d3685af28849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5ed4daa41e0d546f5cf3bcc8bc014b07f5f7e9c0113455ddf7dfb3856ce827b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54d468c22a3c6f189e256663475a4edecb38def544719de48f95c02a08b49c04"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d7a475df6ab2ca6ec30fd0e30a924e41bad42b533c26069c3f7cfea92929eff"
    sha256 cellar: :any_skip_relocation, ventura:       "201755fbdc71478a020286fe7ee5f1d583dd83d8d31665b156a02c49a3ff8fe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c416e6b8e170a537063f6f9a5f82f382afb6e1997bb20d87a04343822b810e8"
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
