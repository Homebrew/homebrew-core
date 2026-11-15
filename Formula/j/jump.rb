class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "17567f7acd305e2e8093f49e591aa03d74bc5c94204b0461550b0bd8055490af"
  license "MIT"
  head "https://github.com/gsamokovarov/jump.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d7a865810c0b3e76b0eb06147455604e031b827a1d10d7abf2711150a6e29c2d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d7a865810c0b3e76b0eb06147455604e031b827a1d10d7abf2711150a6e29c2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d7a865810c0b3e76b0eb06147455604e031b827a1d10d7abf2711150a6e29c2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6e93b19a4501cded7674a6c592b789a2e4381ed45e9256359ac1a14d762a98b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6a893287a10358e6f9e49ce4b488104c784f699976e2761181ac788492a3c056"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"jump", "shell")
    man1.install "man/jump.1"
    man1.install "man/j.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system bin/"jump", "chdir", testpath/"test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end
