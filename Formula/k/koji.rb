class Koji < Formula
  desc "Interactive CLI for creating conventional commits"
  homepage "https://github.com/cococonscious/koji"
  url "https://github.com/cococonscious/koji/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "3d428fe87cb163128b79730d396ae42f408ea1a035e11174de0ac84e63469639"
  license "MIT"
  head "https://github.com/cococonscious/koji.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cc761a36b277b402f160acd6769d7d87e78a073d1238f70604d31480461e688"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e1ab07ddde1a07445a7de66e374a75c6f10dcf3e02c1d32d606f10832b8c244"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea25b8a31acdbc887b187dc57401bc0edaa2ac7268352f18f968d46651926988"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f307d1adfa82da461d9e6823baed76753e7fe209720451037dfecd66fb99ef6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43ab9f19dba5cac126033a2b3744090f954e40ba988436350691d5340d703ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "830f415428a6b7ae48b18baea0a4c4f0e846f23175712271baefa0353fee8741"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"koji", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/koji --version")

    require "pty"
    ENV["TERM"] = "xterm"

    # setup git
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"

    PTY.spawn(bin/"koji") do |r, w, _pid|
      w.puts "feat"
      w.puts "test"
      w.puts "test"
      w.puts "test"
      w.puts "n"
      w.puts "n"
      w.puts "n"
      begin
        output = r.read
        assert_match "Does this change affect any open issues", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
