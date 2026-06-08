class Fortitude < Formula
  desc "Fortran linter"
  homepage "https://fortitude.readthedocs.io/en/stable/"
  url "https://github.com/PlasmaFAIR/fortitude/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "04018554aadd9b846c99b5ffc218fe483c353020daefb777af39a75724a6338e"
  license "MIT"
  head "https://github.com/PlasmaFAIR/fortitude.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3aa77b513f1a25b317d4b42eb5f0414e806bf0b39563d0f98eb24522e755f4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e9f173ebbbc57e9cf0c5691c064da5b758c47efe2f54220d7b362bdfcf3fe62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ccae67fb22d0966ad50cb0d8cabaa5183eaa53061cd29e519f69e2705619c11"
    sha256 cellar: :any_skip_relocation, sonoma:        "400f4d96043009f5b4258a79178f0bbb95d9cb62d9478f497d712d15cea2ff40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "546941a3467143b2291927d1e94ae7b6288781cc3f1c91b6d8ddc32c0f895913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a816f1146d8b65153c7372c856a23f8440068e5ad8aa36e4e79a43ef5acc2a43"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
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

    output = shell_output("#{bin}/fortitude check #{testpath}/test.f90 --output-format concise 2>&1", 1)
    assert_match "fortitude: 1 files scanned.\nNumber of errors: 5", output
  end
end
