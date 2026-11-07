class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.4.2/pup_2.4.2_source.tar.gz"
  sha256 "bd768ca40160fca677bb7f87e39756ae7bc16100013acae3bf0c4e1d8bd767c6"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "789c11b5a3a5e869f855bcc9b382f3297b95e9b2beea3334e2f03502db5a7113"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "74253723c2076697a0be6024a5ed54168e76fa2bda862b5c90f183686935ac92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a328bdc8b9b4e9d57bc3f4bdc6c77c7dcd73f0382b94f7408499321ff66e57d3"
    sha256 cellar: :any,                 arm64_linux:       "1b9e44ef8874785014412e5d6d984a04ff891873f2da2ff2148dab91568ee53a"
    sha256 cellar: :any,                 x86_64_linux:      "d4cc60e4603e8b945ffbf92b4fc3d2697634545b40aedd5c7f3f323b1df5e05f"
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
