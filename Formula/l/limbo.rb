class Limbo < Formula
  desc "Interactive SQL shell for Limbo"
  homepage "https://github.com/tursodatabase/limbo"
  url "https://github.com/tursodatabase/limbo/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "669bc4cbd47c8e9044064a3fdcfc4314b2da0c26c02b804ab27ea2f2eb5a3da6"
  license "MIT"
  head "https://github.com/tursodatabase/limbo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9278973fe1fe8e0565d48e23ae619c29aa4df7b8426840f1930cde9a16b2dc3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c314b2a54c9dfb1932ffdd977dcece17b10e510982c0d2bce400ff55391969c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "715e5d872b780abbaff491f29b7afdce77d82bfd43bc2560c8006ff041c03661"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b0fd066e3d53fe20cf49ab16688b72095a7584e51506d9189f38218dc7df421"
    sha256 cellar: :any_skip_relocation, ventura:       "12d6a0f5b9127ec8c23c1e25911e83a40d22ac863e8b1f0140fe261ff9e8ead0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d5395ab325f4c5a674909561cf92d8712125a52951dba6637949742cc39a00b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a7efa8b7ce5dff9b9a3e9cc4aab101d692fa3d704ee98665b4d1d02c9bce7cb"
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
