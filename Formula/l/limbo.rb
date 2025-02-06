class Limbo < Formula
  desc "Interactive SQL shell for Limbo"
  homepage "https://github.com/tursodatabase/limbo"
  url "https://github.com/tursodatabase/limbo/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "749e1cba2925f3b06653e024422bddfe186672f703e5450e84628d4c61be59d2"
  license "MIT"
  head "https://github.com/tursodatabase/limbo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "902f899296ce0a02adcc3d1e910dd2460ac05d9a5e674ec2deece9bdc5b1c408"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5573a9c8a6de5de4aeb9d51d9d2acfdafca9ec9470789fa47b17b332b76c16e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59d37d144d7657e767565c8a12fa2926f24fc255b02d0b3ef66a7d0502b3d98d"
    sha256 cellar: :any_skip_relocation, sonoma:        "31af23dba4dd7131f2166c4d754e3cdfc2752a57c18fe8780b117c5729777f97"
    sha256 cellar: :any_skip_relocation, ventura:       "ee6547c617f44a0d1d90c1cb0648e07181479042f89fb51961a071a92bf991b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e665147bf20011d7dcfbefcf4e71fdc470dd74bef3e19e32b154d8e688d47f4d"
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
