class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "cd809cbd3f65b116493f29897b06185717d6ac5c7df54cc77e48a231808a348b"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "82ce6ffa55db6869ffdd2eb8c9c7a63f1a29c83bab60e6e2d4209465a093282b"
    sha256 cellar: :any, arm64_tahoe:       "2d9b7ada37558804d1a24fd47de72c1a06be870978dce12a261ebab77db0c31b"
    sha256 cellar: :any, arm64_sequoia:     "4086c95eef2b2ebf3d72d5aa3e403f12a50e63d62a4600ad492dda30fdfba319"
    sha256 cellar: :any, arm64_linux:       "7e5cc6307b0fbc49b52c5eb9f52784ef5ad8db412db7cb83f3b9d1c092ba48ff"
    sha256 cellar: :any, x86_64_linux:      "988738662eb6242c4688d8c1162fc1f0b90995e1cf9b86ab146851ded881a7b2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "vectorscan" => :build # kingfisher-vectorscan uses static library
  depends_on "aws-lc"

  uses_from_macos "sqlite"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["AWS_LC_SYS_USE_SYSTEM"] = "1"
    ENV["HYPERSCAN_ROOT"] = formula_opt_prefix("vectorscan")
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"

    args = ["--features=system-alloc"] if OS.mac?
    system "cargo", "install", *args, *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
