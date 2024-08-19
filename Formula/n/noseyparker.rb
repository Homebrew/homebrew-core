class Noseyparker < Formula
  desc "Finds secrets and sensitive information in textual data and Git history"
  homepage "https://github.com/praetorian-inc/noseyparker"
  url "https://github.com/praetorian-inc/noseyparker/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "cfa74ef3e2e3472823ac712f384e4fbc99f84cc9a9752cf4d22266b4e93921ca"
  license "Apache-2.0"
  head "https://github.com/praetorian-inc/noseyparker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73451211b1237ce2225dbd5a9cae670157855bc01539e74a88530edd11450f09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03b0627b0dc3f78e9e7f9eb4c7ea59825ce5cdaba2238a672ba267f82ca73bf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bdb05e0bd2c3702f2f866f3c4ad3e9379995fb30c4bea806072d49719b77d32"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0df42f329e6028c4c041b521cf0db2733fbf2ba8f48f2c5e20ed568cb8d6cd4"
    sha256 cellar: :any_skip_relocation, ventura:        "0e0651a8ca823494887e7b0d89f88355c21db86fc1d063d267ac9ea1a77ec63a"
    sha256 cellar: :any_skip_relocation, monterey:       "e7f6d40fc849c8eb7ee88e2b046bf8e5708ea78a9b7606bb9f64140edba1f068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a00ef9f997cfd2e90f6d0414985ba9e75653918d77ae47e9fc66f3f8be466038"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["VERGEN_GIT_BRANCH"] = "main"
    ENV["VERGEN_GIT_COMMIT_TIMESTAMP"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", "--features", "release", *std_cargo_args(path: "crates/noseyparker-cli")
    mv bin/"noseyparker-cli", bin/"noseyparker"

    generate_completions_from_executable(bin/"noseyparker", "generate", "shell-completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noseyparker -V")

    output = shell_output(bin/"noseyparker scan --git-url https://github.com/homebrew/.github")
    assert_match "0/0 new matches", output
  end
end
