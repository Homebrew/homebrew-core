class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://google.github.io/osv-scanner/"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "848ead2e06aa6e6150cecc2d82b867da7636d241e50b88f0922511acdac00a00"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "759a306f2dbdffeb47c04e0273514119a177a6c7c2e17656d1bcb85e427aadf1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b3369784d508f294a21f676c3781ff2a3f5c1995631f228b0f6d42a9d67b45dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fbe8eb58582abbee791288988ce77f7fa29ed4c07a0eb3f64cdf23f8a8142c5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "755727d0b0c29fa50001d05fd56645928b534b4e3b735d14c847ddc3d8088c2a"
    sha256 cellar: :any,                 x86_64_linux:      "eec7e684ca81f5c2ca009b341649f1cdff7f6d9a49ca704d97a979bae4416ad9"
  end

  depends_on "go" => [:build, :test]

  # `test do` block queries api.osv.dev
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    GOMOD

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod")
    assert_match "Scanned #{testpath}/go.mod file and found 1 package", scan_output
  end
end
