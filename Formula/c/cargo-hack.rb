class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https://github.com/taiki-e/cargo-hack"
  url "https://github.com/taiki-e/cargo-hack/archive/refs/tags/v0.6.38.tar.gz"
  sha256 "b2232f45b084270dc33ac09910b38082c26bdbb4b736a6a84b3c878c7ae8a3b1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09b306279d820ad18c4b8ff8a506b89a3bff39ccf9f2941b83dbbaf859363d0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49b5a14e2de1321f7954507a1aae843a24e058e2f853b3da8b2965812d30d2bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "865b356936e147ef8f67e2f819c9aff72ba9b4f82458d1241810f8ca6fe8dd43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a76e94d785dbfaa6ccf0664daeeb7448196fc414227f387f12c30f9ae950cd99"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e811dcb036c8f2258cf2683547a48776f319b93f3f86aea00920f73a18e9d53"
    sha256 cellar: :any_skip_relocation, ventura:       "ae58064899d809d62ba44df7614dba6725c7abab6c7b8a2bca5e2db873333043"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d49f7add776ade70ac0ba60947888e0fea3b9610268024d0e11d8db1dc8e30b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "893ddd62281f1c5885c5f87703c25d3e294bf64fcf385c83c13c14523e320e48"
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

    system "cargo", "new", "hello_world"
    cd "hello_world" do
      assert_match "Finished `dev` profile [unoptimized + debuginfo]", shell_output("cargo hack check 2>&1")
    end
  end
end
