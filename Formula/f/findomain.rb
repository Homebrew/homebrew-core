class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/refs/tags/11.0.0.tar.gz"
  sha256 "94a6980136ac1d96034bf2f4b30d4fab15f4c2b4dc1e99dfe226b7e7ca79ae37"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3321a65a560efa9801056d89881b9662cc75bad21a992025bbbbc7b9930de505"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9541c07dd2376b7868b42b8a3ab8ca42ed54ac83aa3131113a16cba58a299ea0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a1d4a583b73e43f77cc80821d7c3e215d0d5f571b91ec548eceedd33307593c0"
    sha256 cellar: :any,                 arm64_linux:       "8abbe284f76a9e4b071505cf6b9d1238a8e5a97901cea73b04183ee6bac71872"
    sha256 cellar: :any,                 x86_64_linux:      "91a850e0c8f9e23ef35c7010106a5a254d54d1b978e4b2eefc630d0c39315988"
  end

  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix(openssl)

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
