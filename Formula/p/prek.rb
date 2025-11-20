class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.2.17.tar.gz"
  sha256 "32ebc2c2dbdce9b7906b23550ed55a3eb50672a01bd52ede9fa50ca1f3c28484"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0291ef1a4ee61bafaa2b823049daec3a133274c22eaf565b9bb34ba1a30e56d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "330b77c5a3f280b7ed7e63db6f594a22b4c14ee46b060bcb60927f7d33e76248"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21da88281f62cbddd143259f008ff9130f5a19dde3ba642d00a7ad3a0bc2b667"
    sha256 cellar: :any_skip_relocation, sonoma:        "0956270211e8aee7fba39815532a67e3cdead3c62abdc9538400bdcc98cccf34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59a225c642a3094e910010ea1e014c11cd4ef605f1a39efdd09a14dbab96bda5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b9f9071a879b9d11d9d2365faf850135ea9ee25586cf7ce227e42c50b7ef6ce"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
