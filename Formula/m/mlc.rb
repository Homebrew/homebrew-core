class Mlc < Formula
  desc "Check for broken links in markup files"
  homepage "https://github.com/becheran/mlc"
  url "https://github.com/becheran/mlc/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "1558d504da177e263d9fe61457745e1c0cacfbd58deaf862dad668be7b204300"
  license "MIT"
  head "https://github.com/becheran/mlc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "641c31dccc26badf1955c0a7e57d5d0c84d79adcae555c117850331837f294df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea81fd5f0ffa185c59a156541d0944a122cad6b41595d38132017e285536d4c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d64d29e139f6f4a6733d2f2d10b29ed50d0c1cd662ecc68b38a95bd7014e09c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88c26288c044ab2288bbb15c7ff1a5be83708c711830eb796379cf128d052007"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f5d049d72d92fd2dea0444951d1677fea8340db347a543a7678bad9252a6cfc"
    sha256 cellar: :any_skip_relocation, ventura:       "658c60504eee6d7976de2ce9acbcc4651cd2993a016ce2f1d1891897a14b5589"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a24f57f05ef9c5369f627d9c904238971567e6d909cfb70fae488382659903b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab3b528ac2aecd470572b9de2d7f2a3e8a8fc44d2463f98a4db637c81d2c9bbe"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Explicitly set linker to avoid Cargo defaulting to
    # incorrect or outdated linker (e.g. x86_64-apple-darwin14-clang)
    ENV.append_to_rustflags "-C linker=#{ENV.cc}"

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mlc --version")

    (testpath/"test.md").write <<~MARKDOWN
      This link is valid: [test2](test2.md)
    MARKDOWN

    (testpath/"test2.md").write <<~MARKDOWN
      This link is not valid: [test3](test3.md)
    MARKDOWN

    assert_match(/OK\s+1\nSkipped\s+0\nWarnings\s+0\nErrors\s+0/, shell_output("#{bin}/mlc #{testpath}/test.md"))
    assert_match(/OK\s+1\nSkipped\s+0\nWarnings\s+0\nErrors\s+1/, shell_output("#{bin}/mlc .", 1))
  end
end
