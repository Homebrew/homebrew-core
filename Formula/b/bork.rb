class Bork < Formula
  desc "Bash-Operated Reconciling Kludge"
  homepage "https://bork.sh/"
  url "https://github.com/borksh/bork/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "718331c54c94bf7eddeff089227c0f57093361f7e6e24066cb544cc9ebd2f6c5"
  license "Apache-2.0"
  head "https://github.com/borksh/bork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "148ee08c6e94140e1469ad74f46f8991ec6b843508011de9c73bd6a80200e089"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5706b3111e2ee682f2386893cf26773bd71e49cc636ef3e84b137b6108dac5db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5706b3111e2ee682f2386893cf26773bd71e49cc636ef3e84b137b6108dac5db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5706b3111e2ee682f2386893cf26773bd71e49cc636ef3e84b137b6108dac5db"
    sha256 cellar: :any_skip_relocation, sonoma:         "e015811e97fecd12d69160b30f0feaf725770162d333f4364f2e62bd0f5a55d1"
    sha256 cellar: :any_skip_relocation, ventura:        "e015811e97fecd12d69160b30f0feaf725770162d333f4364f2e62bd0f5a55d1"
    sha256 cellar: :any_skip_relocation, monterey:       "e015811e97fecd12d69160b30f0feaf725770162d333f4364f2e62bd0f5a55d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3e94ffed31a6f82901865acc743d741b2bfabd153f6f8717acc3a323249ac753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5706b3111e2ee682f2386893cf26773bd71e49cc636ef3e84b137b6108dac5db"
  end

  def install
    man1.install "docs/bork.1"
    prefix.install %w[bin lib test types]
  end

  test do
    expected_output = "checking: directory #{testpath}/foo\r" \
                      "missing: directory #{testpath}/foo           \n" \
                      "verifying install: directory #{testpath}/foo\n" \
                      "* success\n"
    assert_match expected_output, shell_output("#{bin}/bork do ok directory #{testpath}/foo", 1)
  end
end
