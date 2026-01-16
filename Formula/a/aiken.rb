class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.21.tar.gz"
  sha256 "c6bbdba11a37a6452d6a00c6fee9473264b757475912c4dfd9c3fd18ea60ed4c"
  license "Apache-2.0"
  head "https://github.com/aiken-lang/aiken.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c9ae36751833384d16c8a4df43c8fb3ef0755d4b05d3363486b48e54ee207d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffe5ae7edaf537679ee4b86f20e3dfbe7266154ccd640c7103131b97c70e9718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e4d9a6295b7b7f127704e1c3908209878b1d46f0e5655b1d858071530c2dabb"
    sha256 cellar: :any_skip_relocation, sonoma:        "cac6ef2d9163db78866a858eb745edbda9d016956dcf08f0f7d1ad5a3c2e38bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87156bc45bd1fe859eeaebb4307725e38b8ce9098551efec869574f2ce509bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dd61e0126ab3d0b44ea3e085d69d20b36c9fec4cd36fd8431236514d1ec70d7"
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
