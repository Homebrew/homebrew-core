class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "ea7c13a628f4e7ba1224252a7359e3fdb72f9062596de8367928dcafc101c9e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a4cb8c2eab5a5ff052fce60f79b8d1d7e5eb6ec36b848ad04f05ebb7c98b492"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e823d73d9000c4c4d37cdb11acf0d602288e0df9d25210e9add41913b10de114"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "170f7b243c1bd0b506d8972855a5cdfb86588c259d43ddec0658c42995579c62"
    sha256 cellar: :any_skip_relocation, sonoma:        "db7497d7e636ed383927cef9585d3aa7b5d719656c65d012bba976be0715ff8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "843611fb81c8ec6748fe4b1ba5e34e9ccbec21339bd04d175e5b59fbb06b2f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e43d938df7f85715a53008ae255b2ac682339d7fa592973c07627b80ca9bb33"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
