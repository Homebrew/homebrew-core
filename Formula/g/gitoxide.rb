class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "68a60cae90e0882cb3e1e699bc1c7e64902b632cc30209f60444c8ca8b2d820e"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8467a619e4295ff7135e08ec0fa07a9d5c5c133debcc34700f6c9d9829aee0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc3e6f7e8a263387ed2b0461087274468e361a8256b337b45465b59d8e3f7b48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3270a4e3ae80c65881803631f427f8729b9ae7a5365f604ff1eaae0a80c3ce9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b09d5d47561278d136b4597a219a01ca0f532df6b220bf98f6795a43ad6fd90b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71df921b89a5c73e972f1c9bb651713a55578381d2163e394a3c8a42c98aebbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "280801d15024b739e90ab7423bef63825352c5a539c40d11e4b5e66aac4845f4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    features = %w[max-control gitoxide-core-blocking-client http-client-curl]
    system "cargo", "install", "--no-default-features", "--features=#{features.join(",")}", *std_cargo_args
    generate_completions_from_executable(bin/"gix", "completions", "-s")
    generate_completions_from_executable(bin/"ein", "completions", "-s")
  end

  test do
    assert_match "gix", shell_output("#{bin}/gix --version")
    system "git", "init", "test", "--quiet"
    touch "test/file.txt"
    system "git", "-C", "test", "add", "."
    system "git", "-C", "test", "commit", "--message", "initial commit", "--quiet"
    # the gix test output is to stderr so it's redirected to stderr to match
    assert_match "OK", shell_output("#{bin}/gix --repository test verify 2>&1")
    assert_match "ein", shell_output("#{bin}/ein --version")
    assert_match "./test", shell_output("#{bin}/ein tool find")
  end
end
