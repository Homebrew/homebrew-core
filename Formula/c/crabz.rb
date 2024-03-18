class Crabz < Formula
  desc "Like pigz, but in Rust"
  homepage "https://github.com/sstadick/crabz"
  url "https://github.com/sstadick/crabz/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "382b517e459c5798c8099ad0cac425af0c7bf531ea21ee6978fdab0a4f02cb3b"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/sstadick/crabz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3dcb5c8835ec73ab78b1ab1b97075cd8f14cc2fc62912cb005fbe8e71c827c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80debddd165bd37ea5360cdf0be6c11b270feb513a044716a89970615b15881c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "250f395594afef4fcf76fa3fdad71e582a75fa50a5feeb34996b8bbbb9737139"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04d8e5a883bf7f46495c5248b3a197941e2ba47850bf262c0b9b5716b73b153a"
    sha256 cellar: :any_skip_relocation, sonoma:         "17db739a960ce4e09b4552f7eecd5722d40932dab4f254566f2bc76b47dea959"
    sha256 cellar: :any_skip_relocation, ventura:        "83e834149559a7b20198249e53ed3ede7ec70d85daa3f4dfca5c33ebd40a548e"
    sha256 cellar: :any_skip_relocation, monterey:       "65b892644ebc0a701b4c0f9099557c5ea2cbaf6b8307395d7004577164766b57"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccda0fe0e7e5fba9c1ba0f3ca4eea48883878bc569bc9276a3483eab02a215b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f10c994cb0d1bb60460076fe107b2b14940b67d16c0acdbb349219f4f3da59b0"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_data = "a" * 1000
    (testpath/"example").write test_data
    system bin/"crabz", "-f", "gzip", testpath/"example", "-o", testpath/"example.gz"
    assert_predicate testpath/"example.gz", :exist?
    system bin/"crabz", "-d", testpath/"example.gz", "-o", testpath/"example2"
    assert_equal test_data, (testpath/"example2").read

    assert_match "crabz cargo:#{version}", shell_output("#{bin}/crabz --version")
  end
end
