class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "e2b62d114102eb9903e7ed110f69560bbf91b57c3163a256f532ab26dde45a49"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "851aaf1113a28c7a54695e783352c748fc5e5f89550dd7b8e13612692536e08a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "851aaf1113a28c7a54695e783352c748fc5e5f89550dd7b8e13612692536e08a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "851aaf1113a28c7a54695e783352c748fc5e5f89550dd7b8e13612692536e08a"
    sha256 cellar: :any_skip_relocation, sonoma:        "538d9596001e65d42de4377aef8ad6ebd6abda387f2874553cc0b251d5f1215e"
    sha256 cellar: :any_skip_relocation, ventura:       "538d9596001e65d42de4377aef8ad6ebd6abda387f2874553cc0b251d5f1215e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb8d7bbdf767630345c3a08415d373b62815fcf704a485583a6aa53531805d6f"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    GOMOD

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod").strip
    expected_output = <<~EOS.chomp
      Scanned #{testpath}/go.mod file and found 1 package
      No issues found
    EOS
    assert_equal expected_output, scan_output
  end
end
