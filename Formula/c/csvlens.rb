class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "f34428e05d9f7250ee0330530bc1cddd6df8857f8064ccc3895268e5ed522c66"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be7e5769b414887aa2f77d81fb54b55ba466e4e5548c550e520e5ab20f9514b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "092d6f1752a65d8287d34127a018791b5c62793b45624e240613129f8f514c28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ffea0763ffc97598bba70c27272f1578ccbe4f717ced811fac0258843b2cc96"
    sha256 cellar: :any_skip_relocation, sonoma:         "fdf9c26bcca34598d6e3a0f3808b5798760d780466eee809bd6fcba873129163"
    sha256 cellar: :any_skip_relocation, ventura:        "f7a5a3f9d0f1dddf723e2a7f3d38166a72b2fc1e06f6c4ec978507234ab77dcb"
    sha256 cellar: :any_skip_relocation, monterey:       "0f33dcb95ff41247b4425d05e1320623384ecc1d60069cf0e4868559330d4118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "566e17a7eb4ec84337b8bee4c2e95df45537f7e0777304662579ac2e15ad3956"
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
      sleep 1
      # Select the column B by pressing enter. The answer 42 should be printed out.
      w.write "\r"
      assert r.read.end_with?("42\r\n")
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
