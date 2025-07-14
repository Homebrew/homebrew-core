class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "99d172e85b108242da13d51ac379e45cddd2cd79da2ec2e92edb680f78fba562"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b948961570b0f7b21a22155c306bbd315b268646f07b9f890aed2e192618f173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a0b764ac0258c85f57512b576c028c6837e54edadb9fec5a2d702b5e96154f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "404f19214d256a644b4fe6bcb68cb1c30243abb2cab5816051f1609b37fb7601"
    sha256 cellar: :any_skip_relocation, sonoma:        "186eb2007f02ea8d942e492a852e879673b3d92f24175aeb691fec02ef14dff7"
    sha256 cellar: :any_skip_relocation, ventura:       "b29d5dac7669c1b01087b7438812a7c581224ea552d8449e78caee3edce72a80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "151e62e16ba400bf842288a6282a714aa2992611c5090ad3b772b62cffa3d610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85062d3112201b709f5e1a561d6d3b3d3121b1770abb48808abcedc27128ebd8"
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
