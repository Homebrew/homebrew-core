class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/2.25.0.tar.gz"
  sha256 "c9ade471eff5f57e5a6506a08293d8e7ebc54c27e99e33c965313a7108562f35"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "923e9a33991228cfb21a1621c96a100de10662c864631bb0336f47cbae4b5cef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d0098b059cdc9d3ffd9239e58bd923a1913862831c325233ae8388d7ecceffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44e27dfa89c6960c1da914cff90904b9c2733f150931c4073c79ccddac8fb955"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a622dad36ec9375f363c3f92510f59d65c99e601b6c76db4aa8b735223b51ada"
    sha256 cellar: :any_skip_relocation, sonoma:        "99aa5172dcb41f2b0092e8e02734fb45c1e9a682acd91fe7eb860ec4b13341d6"
    sha256 cellar: :any_skip_relocation, ventura:       "aa3b14a43bf08a8b3ae666fbf83f10ad68aa9804356b67e0357e6ca8afcbf67d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1000fb9a4a1aa96292b8b668a818ef9bde5a5884946cc0452e1e8f4b225e157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca38ad24e9781d6cd902d7021b0eb30cc0d401fab12cd769fa809019878dc17a"
  end

  # `cmake` is used to build `zlib`.
  # upstream issue, https://github.com/rust-lang/libz-sys/issues/147
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "zstd"

  def install
    ENV["ZSTD_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args

    man1.install "docs/onefetch.1"
    generate_completions_from_executable(bin/"onefetch", "--generate")
  end

  test do
    system bin/"onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath/"main.rb").write "puts 'Hello, world'\n"
    system "git", "add", "main.rb"
    system "git", "commit", "-m", "First commit"
    assert_match("Ruby (100.0 %)", shell_output(bin/"onefetch").chomp)
  end
end
