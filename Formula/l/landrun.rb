class Landrun < Formula
  desc "Lightweight, secure sandbox for running Linux processes using Landlock LSM"
  homepage "https://github.com/Zouuup/landrun"
  url "https://github.com/Zouuup/landrun/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "c6b2579ba5e30b77ca83dac2b4ba912edb31afe558d7933cedd43dc917df5e7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "2de8d23a677f0f85561215d691275b772fdf57910f3a51ef846634e72161b44f"
    sha256 cellar: :any,                 x86_64_linux: "cfc357624fdfa2dd7def03fece2741e61b538f1509a11fbb2400902dfa523064"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/landrun"
  end

  test do
    lib_paths = %w[/lib /usr/lib /lib64 /usr/lib64].select { |dir| File.directory? dir }
    output = shell_output("#{bin}/landrun --rox /usr --ro #{lib_paths.join(",")} --best-effort -- pwd")
    assert_equal output.chomp, testpath.to_s
  end
end
