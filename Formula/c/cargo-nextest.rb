class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.81.tar.gz"
  sha256 "4894b0012f2ca347b4e205b52f5d5bdcfc1cdf60540c96bd04251d69f10e6353"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ede19779a953780466d474b385adc90f47cc947b8bdfbfced978efb19c5e972"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82050237e97330f0dddbe74e10d9564908e7103bfbb6506ccf0d99293aeaa508"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e2b87c0a76d2e7d36d0c3761a0de88a434893fbdf9367bf12c4c003b971c834"
    sha256 cellar: :any_skip_relocation, sonoma:        "23ac3132e2b37152a3af820c5ba1701c4c07c5b3e6c1ac7b1772c4a4e9c84905"
    sha256 cellar: :any_skip_relocation, ventura:       "20f5750cd61f988e990f6f05b95aeb4c68060ace20a65918f93c0e3e6c71b394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19da719a57e34a87d8fcddcf3c2e94ce6be8c190827e9f8df3e0aba2355fc8db"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end
