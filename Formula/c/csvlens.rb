class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "14b68af7bba6b17542e5e9f64f9225ad34a6c96995817aaab290c5b9090135c5"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47c4e593eede6612973f0bea3d9e6ec8113a454bfa7ce65b59756e12f5925875"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac456ed43cc64876f22b946f577afc8963410dee0d2b374104277cb70a84a80f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a57588a0aba956b0937d8778ed62eb444da956ce1da519e1d7b305431c09c74a"
    sha256 cellar: :any_skip_relocation, sonoma:         "34262e53a6db800f4e440507eca1d938ff57fcc05260e2a201c2c795bc770953"
    sha256 cellar: :any_skip_relocation, ventura:        "968311fbceecb3b0c8dff4f66b6e67b4430d2ca0d6397b2071805fdd524fa07d"
    sha256 cellar: :any_skip_relocation, monterey:       "e636eb9e84ea7830ac01d8013af7de4bdd2960b87a3fa1fd10ea3013ec5437c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f317a844d3f76e2deb9a7dae700ad3b9ccf8b5b4bf1bd2d586d9039d0d2d3ed9"
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
