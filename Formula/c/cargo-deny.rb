class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.17.tar.gz"
  sha256 "74f53614542a393a5c35da323a06f602acdad6eafbde52f9bbd6f8a6c6001020"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd1c830325f79306256d41d7c93988632e50da388194d6f664c573666c35887a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fa5d342d6a03a6dff06c38041218c3cabb5d1dc120c8aedc0d69698992c9c7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea4b068a6333e48b756a785293cb7cf1803139482b094ec41435109945c9a088"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a07a1a27cf9c32b5812d89acb2c4645910c494a265e850d62b7cfdae4c00ffc"
    sha256 cellar: :any_skip_relocation, ventura:        "ae09d351322ab06db46370f0bb08640864ad85ad23295588e9b86770a02f5ba1"
    sha256 cellar: :any_skip_relocation, monterey:       "11ba274c422431498ac52724a1e0b9a4c91021b855de2fdc4260b5fe3babfa58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0cf00380b3d060ef5e0f8f19f14a4f14d0a7108536bbd8816364d55036fdf2d"
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
