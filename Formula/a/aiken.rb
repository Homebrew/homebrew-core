class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.19.tar.gz"
  sha256 "87a74203a8ff4a82aa8c33f07ed4f5fc1fbda9c69a38b13bd2abf24146f9811d"
  license "Apache-2.0"
  head "https://github.com/aiken-lang/aiken.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43233b48701c4054dfe2e0d85828df0d9f415a6137926f049ba5a7c445db8034"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e065b14137f3be1aff198cce428fac2f2a42bab03b895c6ee625cbca200e8b98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a13087d28450285c6e1eeaadc1edeb5967dffbe3e6aad3da7e9a020e5200689"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5727f30a905dd47e0dc2d665fface04471345491b3a78641b8490d7475ff775"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbd79525e346edd3aa8e612b258f53cc1c06c7ab377c0f011444a8d9d39aa70a"
    sha256 cellar: :any_skip_relocation, ventura:       "eff97c253040ee3e4350eaeb56ea8549a2b0085a8ad48adfe4a5958261e0b1b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d792aa271c65084f44a87748a48641336208efbf50621c326fed14b3a39edd88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04816c293fb1ff27d65e1502884b5ae67752453c1ad5b46d07c12d57d7fb5c43"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aiken")

    generate_completions_from_executable(bin/"aiken", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aiken --version")

    system bin/"aiken", "new", "brewtest/hello"
    assert_path_exists testpath/"hello/README.md"
    assert_match "brewtest/hello", (testpath/"hello/aiken.toml").read
  end
end
