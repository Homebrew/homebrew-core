class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "cb3d767cf62fe84c61088936c58767a661d24dc54753e30e2d11ff033695f507"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33ccdb8a460ec8744edb087c5a55703317c25bcbedc319ed97c93ee7da99b8da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bbb94524ea7554ca0e98926a877e60fe80b5d10aa265ad12e8cbee1059b6d6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf2a69cf116b198a840dc5134ea7e9eb4d011a03248b677c1346bcc86bf9df9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b264b0022fc130acbb197a7cf675156094187dd4f17ff7df9b87cea4f1438594"
    sha256 cellar: :any_skip_relocation, ventura:        "bad003b5b161c8dc653a0ee2fb5fd6bdbe3af5549c8b7501537e2fef8ab43759"
    sha256 cellar: :any_skip_relocation, monterey:       "dc33d2f4095bb99fe47446d3e64037cd2b03679a8817de86d8bc6af8b9f9b05e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71bc9509bb0677e5fbd85e26ce9f6ca381d362429a077b42aa106779ec8be9c0"
  end

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
        license = "MIT"
      EOS

      system bin/"bacon", "--init"
      assert_match "[jobs.check]", (crate/"bacon.toml").read
    end

    output = shell_output("#{bin}/bacon --version")
    assert_match version.to_s, output
  end
end
