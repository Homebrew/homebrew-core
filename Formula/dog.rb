class Dog < Formula
  desc "Command-line DNS client"
  homepage "https://dns.lookup.dog/"
  url "https://github.com/ogham/dog/archive/v0.1.0.tar.gz"
  sha256 "82387d38727bac7fcdb080970e84b36de80bfe7923ce83f993a77d9ac7847858"
  license "EUPL-1.2"
  head "https://github.com/ogham/dog.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59c9e37cff1154bb2d7407b0473ab9280156a4144be16bf4bb7820bae34ab27a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c5a4ee2a717b756d3668395a129aebe48e8cc72b049d7f9cfbbfb9d14669de0"
    sha256 cellar: :any_skip_relocation, ventura:        "6a7a5f6ef5f5765f7e642cf03a079a48fd1ba43dbf1aada1aaadec840633abb3"
    sha256 cellar: :any_skip_relocation, monterey:       "0dbeb2271fcbda043b8c67b63463bafbe674e692ed464e891529941e72eecf4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b34f634c60a28d5e5ad7694da962949c677bb1808886c6fcaa7c92579633e5ee"
    sha256 cellar: :any_skip_relocation, catalina:       "0b7f88dc4941328cfb187798bb93f14d32abafa3d867e83161b8682619c868aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55daa95c827fd102b2599978ebbc0fb60d497395388531533891c8d2a28ff3b4"
  end

  depends_on "just" => :build
  depends_on "pandoc" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "completions/dog.bash" => "dog"
    zsh_completion.install "completions/dog.zsh" => "_dog"
    fish_completion.install "completions/dog.fish"
    system "just", "man"
    man1.install "target/man/dog.1"
  end

  test do
    output = shell_output("#{bin}/dog dns.google A --seconds --color=never")
    assert_match(/^A\s+dns\.google\.\s+\d+\s+8\.8\.4\.4/, output)
    assert_match(/^A\s+dns\.google\.\s+\d+\s+8\.8\.8\.8/, output)
  end
end
