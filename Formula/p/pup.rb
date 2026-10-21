class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.1.0/pup_2.1.0_source.tar.gz"
  sha256 "80d6ede5f1568d288fb5bf673eff9e98c79d4b839fa52528e8050bdc78b65f04"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ee8c7aa739e348349f325ee050ad12617211cdcd79e91f1b6a114e1d5692e5a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "363fc1d6f880c231ea3f6f6aaec49c344ede797b2db798cb60bd50702c2abc7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7dcfb8474a06a7993e57c839489944545f084ccce4059ecc41c318087fb0da0d"
    sha256 cellar: :any,                 arm64_linux:       "555952a009d8bcf400ec4dd671ddaf921edf80497f8b417369212096c33984c1"
    sha256 cellar: :any,                 x86_64_linux:      "2761e236626e37338120a618b8d5accc021b7fb32094abb3b8af0b91db6e6387"
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
