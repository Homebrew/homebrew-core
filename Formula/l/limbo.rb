class Limbo < Formula
  desc "Interactive SQL shell for Limbo"
  homepage "https://github.com/tursodatabase/limbo"
  url "https://github.com/tursodatabase/limbo/archive/refs/tags/v0.0.21.tar.gz"
  sha256 "f90fce1586897e9b1d6bb92350834e9a079b60ccbb4f069acfb1b5bdd0781974"
  license "MIT"
  head "https://github.com/tursodatabase/limbo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "438f60112acb8fe48d1f04a5c4e9fdb14633ba74c6dd5ae28a5961c1159ff2af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d76706210af9ab695c190301906c2388e86c1bea8617463681f7a9094fae323e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4997feea9689fe65188e81249c368561fab1bd2ae27d2a891b75587ba544b5dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a35592c83890af03b48fefa46315bbb02160a128cd672d6f9cba50c309ef42b1"
    sha256 cellar: :any_skip_relocation, ventura:       "6410c2c473ba9a4e8e22b7ad13baed75326560c0746fcb51ade34a4ec4eb9f70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80cd28842184acffc40f32e41ee75ce69f1f4b93f2ab7f364c9d6da1b5922525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92dc78a2dc34953ce134e2236eeccb14f7f9af8d0d5d2fc4d1953aef88cac97d"
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
