class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.14.2.tar.gz"
  sha256 "8fa8b3d7fe07f3cc3f3e143d113b20d51258c3d2a7a151fa28edf3f5bb6bf53d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "446b77dafe2aef5e7609706eace19b713518c9130bac13fd2083972d0013398d"
    sha256 cellar: :any_skip_relocation, big_sur:       "e9290a554bb3b0f6628ea885d984509f4a64b3856ab77964ab708ebaf7cd1aab"
    sha256 cellar: :any_skip_relocation, catalina:      "6d456b0c4b9827fe53c1a9db21b474013b1d72b237f63eb2df1a71435e9020fb"
    sha256 cellar: :any_skip_relocation, mojave:        "cd1a741e7030cd6427b6f5531b9aec01a3be66b245f9a4641939fe6820d541d4"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Dir.chdir testpath
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
