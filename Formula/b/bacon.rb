class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "c2a54f858c04649b91e8d6d54c41da9788b1fa8df083e4fb60596663ef8f20e1"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f80854f7a53219f435c7b14a8ec82aa78e063d230be9962fbf7449f667969fcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d060cb275a9b1c79bc7a37785ba706daefb72d259e05cee875582541c93824cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8446e1355a03fad32c185cf2b6e3b28c00a5fbd05bc39007d3ca986d5512c266"
    sha256 cellar: :any_skip_relocation, sonoma:         "0265ca4409281a7f02e91a4d877e552a60bafed7bba553b7b6cc3bc860e5108e"
    sha256 cellar: :any_skip_relocation, ventura:        "3cbbcf9132d53b7ef7170c42c5bdc8824b98ea9b3311fa6571ea515b4fa8d1a2"
    sha256 cellar: :any_skip_relocation, monterey:       "766b763627febaaefffefafa00f3f120af0e7ae1cc4c26f365e6469e6ab92fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4e3ee3b37f7faa42c683529c246228728319c7adf8cf3d3456f94ee3530d265"
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
