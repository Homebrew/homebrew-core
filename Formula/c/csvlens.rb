class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "d653c97c55c8638d2137dfc3b8dcb62f6d76a6786eadc468086e23214cbea3c4"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40ee60cc736bf14bc4d12a582b71f554ddab353783f17d8a262121982686c37b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e9f1365b85960a42dd7fe79bd2a9a8c97aff0cdfd28b45ddc57e80d59310958"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96a69533a99b6d7f4378703a132584f9eff2b621849cd8d7c23de6bc73c3a3f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4169b6cd7e73acbebf7e459e90e8cae6e1c429d60b4903dcce1581aacd83f474"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baafd5f83232eb68564ab84148a75bddbe0dcb593b3436b8d5013bc8469fb68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "092886e9e8b21b94574be7eecc864aaddcc66aa3e7cab7acc560c63d4354c943"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"
    (testpath/"test.csv").write("A,B,C\n100,42,300")
    PTY.spawn(bin/"csvlens", "#{testpath}/test.csv", "--echo-column", "B") do |r, w, _pid|
      r.winsize = [10, 10]
      sleep 5
      # Select the column B by pressing enter. The answer 42 should be printed out.
      w.write "\r"
      assert r.read.end_with?("42\r\n")
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
