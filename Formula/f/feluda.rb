class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "3a5bb932b07a7f9e8433fb61ee5e8a7cea8648e35d5d58001a77261f6b42e917"
  license "MIT"
  head "https://github.com/anistark/feluda.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cf27d193ce09625ecaf450dfde026d41ec3b79589bd403adba9fdf3f0e46cde0"
    sha256 cellar: :any, arm64_tahoe:       "24b45110ba49ce61728bd9a6cdcbac2891debd3b7ddc176c2f4f93ac4e2a114a"
    sha256 cellar: :any, arm64_sequoia:     "f5a31c5fe52eac0075ed53e994752838dba8d9b2b699880604894e8fd76bdd2c"
    sha256 cellar: :any, arm64_sonoma:      "bf5dbe9b74fc166acf2f639f02b7a2f2ab34a472e7b25a4c6616f4f0ed8ae603"
    sha256 cellar: :any, sonoma:            "bf4b63689a3f5725ee2f1dec4f28cc95a109e7a182aa56fb15a1d96e60d41620"
    sha256 cellar: :any, arm64_linux:       "474e4dce4532d40a7f59c802e2be03d5d48dfbe303d176c7d625694e771ce1f3"
    sha256 cellar: :any, x86_64_linux:      "216d7d3ceb826964ef28cb3ecea8d58be9eb043cf8558680b3744397fb796b22"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath}")
    assert_match "❌ No supported project files found.", output
  end
end
