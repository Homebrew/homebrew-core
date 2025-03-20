class Limbo < Formula
  desc "Interactive SQL shell for Limbo"
  homepage "https://github.com/tursodatabase/limbo"
  url "https://github.com/tursodatabase/limbo/archive/refs/tags/v0.0.18-pre.2.tar.gz"
  sha256 "f9cd490782386d3288185d5d1e5524af0af080f237148a19cea6bedd54ffb0a6"
  license "MIT"
  head "https://github.com/tursodatabase/limbo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d16dd128bb231a5350944f62b9bdaa698bae5ffec78ddf97cb9c80601f21c6f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44a672b940eac21b6602e6c9517cfbaaed4a3202050603ec97d691dbd2a7fced"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba381173b915516ae51bd1ae9d5bd192b048b2161ae9d467ff706e490e57b50e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d50294803b9e65ce5c4bdd9917f3320b1d8d8bb4335bee263cf29bf089b8691"
    sha256 cellar: :any_skip_relocation, ventura:       "3c96f3c23052c23837e8247793c5cb8901b3b797e4e210278d0f4f8218e9059e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce7ef5b1031a07f8126118895bff77302433c1610d55ad074968a52ada72bfa3"
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
