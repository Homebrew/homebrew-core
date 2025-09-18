class Prs < Formula
  desc "Secure, fast & convenient password manager CLI with GPG & git sync"
  homepage "https://timvisee.com/projects/prs"
  url "https://github.com/timvisee/prs/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "c337537b9c9b383354a30cb1a945502c8c3e77baae725336b614f1a6655e9a6a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c601d9f165fc779d898a5385e5a7c6bfed09c8c957d72943d4f69ea61ef1647"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b5f4c10e5803736aa33b24374ac4bd0245f7a0cc3f4874186532e9d18f9becb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32917e76e77b580dabff4b6f6eb02e044f2020672df5379dccdf4cb1d90e1ac7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4c23d1dc64cc2181576837b8f13c509cdf7c98d881f2b4d0254da176d6657fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f0b42fe5c901a5f0d6fd6509352776c9c4a74a1dae1921e0bffc7795358cd43"
    sha256 cellar: :any_skip_relocation, ventura:       "c10624e1174146ed242f23a7825c8919207c90c9bd1bc16c21ff699091b6323a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa938ce8223c929a4f21163b088560232242fe6f5bb05d9e188773fc7eafbdf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fffbfd4b4d36bc614005a4dc8dd2cca6fcefd336b014da1da6f8550713e6d9c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "libxcb"
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"prs", "internal", "completions")
  end

  test do
    ENV["PASSWORD_STORE_DIR"] = testpath/".store"
    expected = <<~EOS
      Now generate and add a new recipient key for yourself:
          prs recipients generate

    EOS

    assert_equal expected, shell_output("#{bin}/prs init --no-interactive 2>&1")
    assert_equal "prs #{version}\n", shell_output("#{bin}/prs --version")
    assert_empty shell_output("#{bin}/prs list --no-interactive --quiet")
  end
end
