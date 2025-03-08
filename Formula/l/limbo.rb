class Limbo < Formula
  desc "Interactive SQL shell for Limbo"
  homepage "https://github.com/tursodatabase/limbo"
  url "https://github.com/tursodatabase/limbo/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "3e30edbdebc8a0a5695b30e33b8324fd162ad51e77761bcbac6103f071cd7ec6"
  license "MIT"
  head "https://github.com/tursodatabase/limbo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f56e927b2b0305020f79d83dc1f083a080fe17ff5cef3995fb30b3a52f6bd33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a79e7f378d251e0bef78520e197e973cb5e98e570825bbd6c5c498da20d43323"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1876b5ef1f2d45719ddd161a323bd8e5e9ec69e015aa0259dce90165bf701dee"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5137e5c5286a8498d662ee77067385c7c3ec88d9154fbb858052898d6d414b4"
    sha256 cellar: :any_skip_relocation, ventura:       "b504ca773f5c4672cf6647c6315a04e5e929399936a72903a6f6da01ec513722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2884fa23da88ff27c70b1dae40ebf5dea86d7ce8ce86a0ebbed75bcdbb298dbd"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/limbo --version")

    # Fails in Linux CI with "Error: I/O error: Operation not permitted (os error 1)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"limbo", "school.sqlite", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "\".help\" for usage hints.", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
