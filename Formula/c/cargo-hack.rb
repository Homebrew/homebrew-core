class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https://github.com/taiki-e/cargo-hack"
  url "https://github.com/taiki-e/cargo-hack/archive/refs/tags/v0.6.41.tar.gz"
  sha256 "93ddd70dc31187b0009a02baf4503f510c7c4f8098fb77c11ba45200f0bd011f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c3af8a3497a396fbd644035486d1a7a5c0988ab9644bf424b0a5566db53a70c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66deb50b39da7b108a040dfe8544b5a4a66361e5a22b752a45ac24effe375769"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e90c7f4c656c4975c1bc98d6ea9ee93e344ee5e2273ae88c41f4bcb78c7a1334"
    sha256 cellar: :any_skip_relocation, sonoma:        "174ad68104ba651a189c7af147e3e98802fe96c5b3c97d46b76ae7ab0a39b2b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11572c756e1a0e7636353824f8ffb07c2b67f72718c56186364b02502d23a0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2890ef339e354cdf9de1c8e87796af38126cf41cae68d71e15e555756ce31e27"
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
