class Fortitude < Formula
  desc "Fortran linter"
  homepage "https://fortitude.readthedocs.io/en/stable/"
  url "https://github.com/PlasmaFAIR/fortitude/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "1b03901650199fb05e6c9f7afda0789b67a73b52bb0bf0f9d3e877b47890c736"
  license "MIT"
  head "https://github.com/PlasmaFAIR/fortitude.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3171afb506b4cfed8e1e0c46884378c022baacfb0cd634db0c0151485deda2c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cfe64c5e4f99dbb1d7c59ebe31c6c36bb96687b810ed107153cfda100b0e9c16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00595d6bd8317b93079c06fca3360b8462833e54cf125efe94e448f202fa1058"
    sha256 cellar: :any,                 arm64_linux:       "9b37f393a67578d9643fa3358b0068301dd5b131ac80d0b63ded8ff3f52bee9b"
    sha256 cellar: :any,                 x86_64_linux:      "d83e2071ce217cf97fc2fb0c2de1acb8b8310c7f3471d15aa224f0362f261a11"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fortitude")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortitude --version")

    (testpath/"test.f90").write <<~FORTRAN
      PROGRAM hello
        WRITE(*,'(A)') 'Hello World!'
      ENDPROGRAM
    FORTRAN

    output = shell_output("#{bin}/fortitude check #{testpath}/test.f90 --select C001 --output-format json", 1)
    assert_equal "C001", JSON.parse(output).first.fetch("code")
  end
end
