class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "7143136d86fe08a771d12b2b5a96c4d185b98d0e5dc81926ffa800f4e0ea168a"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15c0c1af037d2ae7d394067db269ad3b6414f78c8db6917adfeef54dd8370b08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dc16ceea72192ba274dc1414332b4427b9f0ba4a2f287a650db97f8ffc8d08c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a1f8adfab9fc2b06805652322c69dbb47669b0b56d2e4521231d8e6878ffcb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9862343641ad476275c507618914951807390770b12c73bbcbe1a3a5189ac602"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbe67a50e6038bc715566df00b9055077c35322a9345cd550f2d7fd45024b2fe"
    sha256 cellar: :any_skip_relocation, ventura:       "e2fdb967c1258952ba927ab577cd6bbf7147f571dd03df4d3b177561a96909e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2b850bba5dae46b65a3877429b027360bbc6b31c0f7ed22a2f7f0011b77afe4"
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
