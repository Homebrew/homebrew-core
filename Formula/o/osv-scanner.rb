class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "b6ff65f82e833e2d8102e3308e620ef30af5f93b3a215f899098be9a3e21ad03"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffeac8763f0eeb760aa98c9007c6f909598aaaa0e96299dffd94fd772c9c077a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0da45074f108b9f211fa344112364c61ebfd17b447291f5ab423e73a0d9767bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35e921d180a6ca495a2dcca9dfb0adaed2a5810436d529ff169eca6c2ec75a19"
    sha256 cellar: :any_skip_relocation, sonoma:         "49f6e4bb7aedcd4cc694a6d781848d413c82ea9f82579da3a3a2e3849d07c117"
    sha256 cellar: :any_skip_relocation, ventura:        "e18919336d9c2895e0385609addedfa21d46a814db57b2167fb06a016a80d3ba"
    sha256 cellar: :any_skip_relocation, monterey:       "9411934eb9a039faa8c7f8807a545de7339c49fb4c1805870c255e72b33c8f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2a5ee417e88b92f62db963c5852bbbc03bdcaa0115961e9bc4f965cead287dc"
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
