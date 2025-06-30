class Limbo < Formula
  desc "Interactive SQL shell for Limbo"
  homepage "https://github.com/tursodatabase/limbo"
  url "https://github.com/tursodatabase/limbo/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4ca02cb8ddacdc6b0657b38f7773a6308cf99d64f5bae233bbe5b1f7f9184a18"
  license "MIT"
  head "https://github.com/tursodatabase/limbo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9084312f47b1a4728191d7c8fd668a2370eea706b69b6e169d30607563f620c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f366ac109efc0adbb8b110c00b624687ae298cdcecddf8e2b5cb553d87d9913"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "404ce7a766654d3a3792207eef8547bbdf698d898af2b284531d94b9001f23d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb8fcb114abac4554dc183a92e26f5dfcc02385d7213c6c78a32584e26aa871b"
    sha256 cellar: :any_skip_relocation, ventura:       "7dc9ea985267d40a3b1377fed2ce6ab7c3f191d6773f83ec39b1956f487eb700"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a52a85b519b3d278f3b12dbae03b8596055312f4d584c12fcb6c87d3f5471387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a45203bc6edca65de1a05536f7e43d8975f6cbdec0b8e694c32f14fd7c35b2e5"
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
