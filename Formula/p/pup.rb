class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.4.6/pup_2.4.6_source.tar.gz"
  sha256 "4f6052625cbb29c76510043f631be4b8406c79a7a815b36dfacfe6c395a13691"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8620798d5fcf937a9906b1120b60beee9ac4c98e16199480f86b6537faae1949"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9ffa43df64c3732e7b1c07a9932c663da19be3723761e7d343dd0cf2e8658fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f512283e35a450f9dc8c3b63d83d39e2eebab02b9b4633a08c102a84b1dcaa6"
    sha256 cellar: :any,                 arm64_linux:       "194eb8166572abf539f7322afd27ce57b7309c036b9894c8f00471f8efaf89ec"
    sha256 cellar: :any,                 x86_64_linux:      "9c4bfc8dc6921918d65ba21375d97c3ec8f9e8d0aed13a29ecb85fedf9d95612"
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
