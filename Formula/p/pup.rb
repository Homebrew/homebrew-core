class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.4.5/pup_2.4.5_source.tar.gz"
  sha256 "709d589a9f9bebea8750dc44d3ebcf9704f626b9cc12a784107af9af65fe0ea2"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c77edc7243f2e2283ab3a82920ef8df9e4ae633d39599158adf9efbe2cf0f958"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ff5be35d8e70f683e3b0f39a1038be94d431bed65a34111afb8b3c9716ba750"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cba9ce63d40e9b221967da89f2ef05e640b5da5d1ed7e11e760e516b7aeb1832"
    sha256 cellar: :any,                 arm64_linux:       "5dc95526ee699479702c877ca98ea0b45f2598318cacd3bad238bc207fbc8b12"
    sha256 cellar: :any,                 x86_64_linux:      "97113d3cc49d8c1162bc464c86444401c9b1b15abdf5d8c52446ecbcc4247c83"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
