class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "15480c07c7e69b2d54f9c3975e0ce8ae17b85f7f0a291e50d8fc1a0ff9cb2b17"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0814c6021e1a16288033d5d115f2d0fb66a21b9c0e018a7604458f24cf20492"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ade87fd9b2c3dd9f64d7ee4427b2266d7e9cf92fdb0f99f49eae0df4cd3eb27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95f757052cae81df4cdca485d6d6dc0aa5d684ad1c44c2d1c6fa82efde037dca"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b15fb1a39c70c6e8aa8890d2efb1fa452b43b47fe0f3165e655cc46345b587c"
    sha256 cellar: :any_skip_relocation, ventura:        "6084a515748e80187390bb54051d000faaa5660711c62cecc50e090b0076f917"
    sha256 cellar: :any_skip_relocation, monterey:       "fb3fb1b6051f1128092c2903ff283fc056ba989dc0618d406f6cf523f82e768e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8606027d0398d9d644ebc072642313aa3468bdee1e6351d3e612ec4fed743e24"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~EOS
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    EOS

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod").strip
    expected_output = <<~EOS.chomp
      Scanned #{testpath}/go.mod file and found 1 package
      No issues found
    EOS
    assert_equal expected_output, scan_output
  end
end
