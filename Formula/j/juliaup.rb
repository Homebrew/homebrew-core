class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "11bb74282b93f5b335b72127e3c3bae74b0e2e026d153f12edd197e973be2b99"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc941d8f25a0afbed49d5e5380d8e262ce3f0afb5a8e88ba501c667983b8376e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87c638dfd6663bfe3a74546d765b261d2189197f8ee482722ff981dd59f80898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e3f01c4512d6ecfe67f4fdf86b5ea75ced2e5490a4ccf64d05e2ff09983516e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2bdaff539b55e495838d93c56b0d49a92caf1751a7b00ef79656045e8a83e85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "957181ca2e54e89eac0bf000aeed9e9666227b378b3a9ce1e8654a5255e8cc51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99718aa91e376a9256019e302a5c3f265148a7327a0d4d718092d6c6576e95ad"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
