class Msedit < Formula
  desc "Simple text editor with clickable interface"
  homepage "https://github.com/microsoft/edit"
  url "https://github.com/microsoft/edit/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "41c719b08212fa4ab6e434a53242b2718ba313e8d24d090f244bb857d6a9d0fd"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd62dbac464d403a1d01ca2b1dc5417cf0464722ed5046f9b2817e6dc001e6cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26108335e5657a2edcaeeb2e733774c0ca17f252579570dd57f3305e9fea9082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67edc565c938a4a51ad0e295b6dcc499457cf85cd0f443040cd81bb42cc36a2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab51f79acc7a99a93dde6e3d150f0888eee399e8ab91e3c624f6019694426a2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b8aea7360ae38105ca7172ede2e3a6ce8cf8b217a05307d7ba38aae70c55964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7ea7cbd48b0add90c97b5dbe93a1c8945e46afafb367ca1433e53f7990b607a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    ENV["RUSTC_BOOTSTRAP"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"edit", "--version", [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/edit --version > #{output_log}").last
    end

    sleep 1
    assert_match version.to_s, output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
