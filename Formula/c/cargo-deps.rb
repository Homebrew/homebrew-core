class CargoDeps < Formula
  desc "Cargo subcommand to building dependency graphs of Rust projects"
  homepage "https://github.com/mrcnski/cargo-deps"
  url "https://github.com/mrcnski/cargo-deps/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "b570902b2225f1cf8af5a33d3b77ac4bf04161ef7e9573731eed97715efa9fd3"
  license "BSD-3-Clause"
  head "https://github.com/mrcnski/cargo-deps.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6817f6aba18ea54427289043559801aabc573370c80aed691e9ae78893046348"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbfa6ef183d5a237a74186f332915c4704ce9926be46f30bf67d21a93443fc50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72e3032013ef5a554be4c6c0d1ce750a863cc8d6ba0d5aeb631bac9f96dbe832"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6a439a94c145edf47da3e56d8ddc476d7d70e6f02e0e25bb62b5ef2436859ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "faf4a08e986ea2ae4c5da48d6b92237a1cba2a5493c807b50c3a4f454555749f"
    sha256 cellar: :any_skip_relocation, ventura:        "dac2b73dceb1fd9ac07d9ef73b5c087c909c11af4cc67965be784628c2aea806"
    sha256 cellar: :any_skip_relocation, monterey:       "3f0b24ef58ceba9d2232c3ddf0f826b94c0a9347d0c9bc84055c1445d57a9972"
    sha256 cellar: :any_skip_relocation, big_sur:        "524f11ed7795845ff1014f495a783b0c3db46900b14c6e7490b093fbe4656308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "205f88a20c0bf8fdabc555ecd1ec72a6103f65dcaaf5dc8c23f687e6d78249d3"
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
        fn main() {
          println!("Hello BrewTestBot!");
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      EOS

      system "cargo", "generate-lockfile"

      output = shell_output("cargo deps")
      assert_match "digraph dependencies", output

      output = shell_output("#{bin}/cargo-deps --version")
      assert_match "cargo-deps #{version}", output
    end
  end
end
