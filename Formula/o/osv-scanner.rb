class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "2e36bb23c87665e0081b1d3d538fe342cd27d041d864158d099f3c1a9de6de31"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52f4f23817db956fa09254e51e50396f2005d65ac94095872d96ea1c1a19381c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b03251f96137804d2c70ede75a18a308531bad00beaee9e5a3e03985d355d2e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e05ec0b9fdd3a82c70726d91f24fc05e4b1cb84637b291aabf270c97a1494b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "57015bda52560d8215f618be282a2edd4681de8bac48c823a80262964909f73e"
    sha256 cellar: :any_skip_relocation, ventura:        "63da7d16ca6c499ad0f10ec7c93de2287be0b4a9f634aa0b7a69f04e7dc8de7f"
    sha256 cellar: :any_skip_relocation, monterey:       "7973294813277b395101593369e9fde703879ed820d8032d5f63b2740cc64bf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f32efb41d15983ff3b95495d49ec7adbcae704d46659e9f5d0cd8b97a9fe5cc"
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
