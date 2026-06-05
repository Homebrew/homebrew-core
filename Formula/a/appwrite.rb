class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/22.0.0.tar.gz"
  sha256 "aebf5766048c292aa04d72cdde40dc7a9afdf45409f65a62ecca2837795254ac"
  license "BSD-3-Clause"
  head "https://github.com/appwrite/sdk-for-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51f537279f972c970a46b2003d254c03a055d768c8459e1cc82753525e85c04c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ac4a45dedfebaa095f696f4b7b5aefc1a0f3bbe09429f763caa48fece113890"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ac4a45dedfebaa095f696f4b7b5aefc1a0f3bbe09429f763caa48fece113890"
    sha256 cellar: :any_skip_relocation, sonoma:        "49e403c2fdc661aa3e35a20e2af3cc3e0e16c695753df17ca60be9e66d20ffb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a787b01e9dfe15c0f04b8602a000de3588bc135817203d7dd2846c3b33a149f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a787b01e9dfe15c0f04b8602a000de3588bc135817203d7dd2846c3b33a149f0"
  end

  depends_on "bun" => :build

  on_linux do
    on_arm do
      depends_on "patchelf" => :build
    end

    depends_on "icu4c@78"
  end

  def install
    system "bun", "install", "--frozen-lockfile"

    if OS.linux? && Hardware::CPU.arm?
      system "bun", "build", "cli.ts", "--compile", "--target=bun-linux-arm64", "--outfile", "appwrite"

      libexec.install "appwrite"
      mkdir_p libexec/"lib"

      icu = Formula["icu4c@78"].opt_lib
      (libexec/"lib").install_symlink icu/"libicui18n.so.78"
      (libexec/"lib").install_symlink icu/"libicuuc.so.78"
      (libexec/"lib").install_symlink icu/"libicudata.so.78"

      system "patchelf", "--set-interpreter", "/lib/ld-linux-aarch64.so.1",
                         "--set-rpath", "$ORIGIN/lib", libexec/"appwrite"

      bin.install_symlink libexec/"appwrite"
    else
      system "bun", "build", "cli.ts", "--compile", "--outfile", "appwrite"
      bin.install "appwrite"
    end

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
    assert_match "#compdef appwrite", shell_output("#{bin}/appwrite completion zsh")
    assert_match "_appwrite_completion", shell_output("#{bin}/appwrite completion bash")
  end
end
