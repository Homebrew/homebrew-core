class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.18.tar.gz"
  sha256 "0a01ad3390dce30f5c8b8eb05145f10129acdd8858aee1d037e346687735b09b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ef1e46b927f5c4801ae4c8d031c85017f208915718b3e20d7aad02292c556d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4a1381d22722f4814cf9e3f3bdf8d02609a66faf6fb46021c4419f92d23674a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed996f326ac06aaac3f837de3314accd65d217ddc69e75cc2e5889b6d6827f56"
    sha256 cellar: :any_skip_relocation, sonoma:         "b96fe851b41c70f4229f2e14223d2010ccf6b0eddb7ec8c9a9a1edeaeb9dbe2c"
    sha256 cellar: :any_skip_relocation, ventura:        "b44306efe48524faaca0379951a50d786e5c2e95ec95785dd8c9b50498762f91"
    sha256 cellar: :any_skip_relocation, monterey:       "bce3f51d86e227ea33cfdc56a1a413ede38b100d1cb6e08a1bc4bec81d74af96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "937c2dd697e143de88d6dddcb1630df6ffa63e0aeffb10a4ce8b5bda7f36b62c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end
