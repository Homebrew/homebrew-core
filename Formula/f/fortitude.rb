class Fortitude < Formula
  desc "Fortran linter"
  homepage "https://fortitude.readthedocs.io/en/stable/"
  url "https://github.com/PlasmaFAIR/fortitude/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "90ea53522c423380079a58e5f8c813d01d487756f25aa3cc1b40a2ce2f55e7d6"
  license "MIT"
  head "https://github.com/PlasmaFAIR/fortitude.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db7e886c979d9ba7478bd577ab59a72b7caff475384c6923a84b60ce33f75ba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cc085a2bf4e106de34b4a1dd7707b623e9d765261f03c9b84c4da52671b3cd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04ed4828a178e34842cfaff2c97a85f27865f6d88d1bdc41dc16134aac757a8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "de4c8463acc9d1a22a7ee49c779252b87fa3b8d9aa8fbf2d7807643caeb62ea0"
    sha256 cellar: :any,                 arm64_linux:   "f293c61552b068b8e96b84176b53459303a04dba4ddfb56830c88dd4c015cb42"
    sha256 cellar: :any,                 x86_64_linux:  "6f4d21f8601f25ac226a1a649abe506047f1da590e767ccf5a59cea2c57b4c60"
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
