class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.6.0.tar.gz"
  sha256 "b2967f406d68cb09dff8ffea4f60c398ad873a41ac19e6a841e30e22c730791d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f68c5cab28206fadb564f307eec415af228a0826cdc333c3871fe2474a04913b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f9a7afc42179394e9f7e59cfd1be64570bd3423301a46a23d2b9469e4917e50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad85f4f57d15423292f17ed4006ede0abdccc1b2b0e2f96b20ee69838dbb3445"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5c7badd2b6e3246421773aaa88a28e0ba7929b2185936043441b867574955db"
    sha256 cellar: :any_skip_relocation, sonoma:         "3abf8d0bcee577c0cebf6e540a9e0ceccd3a95eaae3745f084e1410d5f9d00ca"
    sha256 cellar: :any_skip_relocation, ventura:        "fe059d715c823da6dcc825e0d6760ea47d8e0684fdb8d0bfccf68941a7c51418"
    sha256 cellar: :any_skip_relocation, monterey:       "aa95d7469c85531953d7af2e5cd9a40d25efffe3c06212095a654120d4cde548"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebf088047cd1f6929066ea706c3b54f49c3aab1d658a8b305cfa4e896ee77f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13c35e30939a1b4286dd7104bbe3b36e509c1106bc36ad343f1d83e6de782655"
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

      system bin/"cargo-about", "init"
      assert_predicate crate/"about.hbs", :exist?

      expected = <<~EOS
        accepted = [
            "Apache-2.0",
            "MIT",
        ]
      EOS
      assert_equal expected, (crate/"about.toml").read

      output = shell_output("cargo about generate about.hbs")
      assert_match "The above copyright notice and this permission notice", output
    end
  end
end
