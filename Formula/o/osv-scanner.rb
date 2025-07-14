class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "129f534cb55c0811dcf80efec9da7314a4fd87255c093718db9502a4ba19f704"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec5cad814337816e826a46f822f3489929c9926fdbdd1dbab6e52ed52ac2384f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec5cad814337816e826a46f822f3489929c9926fdbdd1dbab6e52ed52ac2384f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec5cad814337816e826a46f822f3489929c9926fdbdd1dbab6e52ed52ac2384f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e24d69875a8abb1a7564204dbbcc8f5306f789be00b7807e743f0d2c5e4764f"
    sha256 cellar: :any_skip_relocation, ventura:       "0e24d69875a8abb1a7564204dbbcc8f5306f789be00b7807e743f0d2c5e4764f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "417907380b2a6ce861aa9116f66612e81d48cc6a743aef26d4367bbba5c5a13a"
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
