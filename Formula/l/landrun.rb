class Landrun < Formula
  desc "Lightweight, secure sandbox for running Linux processes using Landlock LSM"
  homepage "https://github.com/Zouuup/landrun"
  url "https://github.com/Zouuup/landrun/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "1ec505759bd83084af595d20e8296731c9fc94e7225c711c927fdd72984df256"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "2de8d23a677f0f85561215d691275b772fdf57910f3a51ef846634e72161b44f"
    sha256 cellar: :any,                 x86_64_linux: "cfc357624fdfa2dd7def03fece2741e61b538f1509a11fbb2400902dfa523064"
  end

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/landrun"
  end

  test do
    lib_paths = %w[/lib /usr/lib /lib64 /usr/lib64].select { |dir| File.directory? dir }
    output = shell_output("#{bin}/landrun --rox /usr --ro #{lib_paths.join(",")} --best-effort -- pwd")
    assert_equal output.chomp, testpath.to_s
  end
end
