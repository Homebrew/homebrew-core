class Limbo < Formula
  desc "Interactive SQL shell for Limbo"
  homepage "https://github.com/tursodatabase/limbo"
  url "https://github.com/tursodatabase/limbo/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "1b13620223cd2341b103ce4b1cc80f0072645bca1a267a7277e42e5bc65a4c91"
  license "MIT"
  head "https://github.com/tursodatabase/limbo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "157877270a39667bbefbc0866e7a382aff7f90f1a7b091fc625bf7091832fed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb488250867c8afd6d5e435f8309a966b827e60f7fb540254715f74c7781a8c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f921d76ceee558d71a25cad45a3f45041dce3d0c8b93e5644695ac7e60abaa49"
    sha256 cellar: :any_skip_relocation, sonoma:        "6690560814c95a1352f512b64d93ffca8ba7f3a97bed416bf5f7cf2b7c041165"
    sha256 cellar: :any_skip_relocation, ventura:       "2721a0ec64d053b6a2fbe0f21d908694e48f65db644680ca4fb31723217820fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "159bd72c02e7471aaceee4c1f3b71ac0fbf4569c2f00734841616e4b25f3481b"
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
