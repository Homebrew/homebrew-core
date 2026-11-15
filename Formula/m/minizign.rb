class Minizign < Formula
  desc "Minisign reimplemented in Zig"
  homepage "https://github.com/jedisct1/zig-minisign"
  url "https://github.com/jedisct1/zig-minisign/archive/refs/tags/0.1.14.tar.gz"
  sha256 "cda224ceb7d6adb25b99f313f89212e4f6272f41108c1e6eb2a6ea2a05cedc34"
  license "ISC"
  head "https://github.com/jedisct1/zig-minisign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0e4f46ada73e31793e4bdee42e19dbfa9421ae0e1086e1b0f1c72bea42e0080d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "34ac32cec571e5b5394abc6783d05bb72a6a7188ac3ce86b222d01e19aef100d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb1471156e1e04eb60aab7d544544fbb7fa55c3fad7eec69cbf6ddc98aafadaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "be405b87bb94707b987a27c25befe70e6752339e1e9630db14cf06dbbfeb3541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2c61ead0170fb9c84a746031bcdba735ce9e6d1b1add6e3bad1669449fdc3419"
  end

  depends_on "zig" => :build

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    # Generate a test key pair with an empty password
    pipe_output("#{bin}/minizign -G -s #{testpath}/test.key -p #{testpath}/test.pub", "\n", 0)
    assert_path_exists testpath/"test.key"
    assert_path_exists testpath/"test.pub"

    # Create a test file and sign it
    (testpath/"test.txt").write "Out of the mountain of despair, a stone of hope."
    system bin/"minizign", "-S", "-s", "test.key", "-m", "test.txt"
    assert_path_exists testpath/"test.txt.minisig"

    # Verify the signature
    system bin/"minizign", "-V", "-p", "test.pub", "-m", "test.txt"
  end
end
