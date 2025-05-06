class Limbo < Formula
  desc "Interactive SQL shell for Limbo"
  homepage "https://github.com/tursodatabase/limbo"
  url "https://github.com/tursodatabase/limbo/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "ac28707be9e10fc6d29b1da0d4dfea55f4b3a87120acc7e33a8d22c49b8f5f8c"
  license "MIT"
  head "https://github.com/tursodatabase/limbo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5abb8170d72d1b50fb8447c5c3df614556491ff27c7e9938523f8a3a72cee827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7cf1695ab12e211e75257f973665be767a8ff1b0c13621fd01a23ebd57f3928"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac7ffdc473b6e1a7c09128be8b086903961485162e73615ca9c066af1e86ab0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c29f5b7b9ca2cd66748a7d30f88a4231f13d7324cc85da6b9529bd5e6c563eff"
    sha256 cellar: :any_skip_relocation, ventura:       "59200229349395e8a65eb2322bfb9ee281da2b644132f354f00d91edd61b6c6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b0a481edbc7a16e5b3d68a7e7f48e5c209517f24e3938c75ccc36c2ad090e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35e41397bd4b0929ed12c109c85c62ea57dd9349dabb17292a217c58eb29e615"
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
