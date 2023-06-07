class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.33.0.tar.gz"
  sha256 "36a11d731dca289e6e638930f4731fa86148ddb61038d1379441735a9b585f61"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d1bb22601cc7e3578601b91f1e3a8c5fd9d4617833ea3720b7876f6add0216b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46897c26877afe278e0c77164d39f2faa4d51c374effd56ce51c6b7bae886d74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c751e4669afb641302e48bd72da6ddd666c4a284e535649edb01141c9812f3e2"
    sha256 cellar: :any_skip_relocation, ventura:        "b43d91b0e79a1523fe07026382dc5357927eccfcdb05c98f9d0e3738c49d78b8"
    sha256 cellar: :any_skip_relocation, monterey:       "6d6aabf6102940463a047b186cb08df7b7cf013c16f8ed48fb70f4ec2e956702"
    sha256 cellar: :any_skip_relocation, big_sur:        "c792454928495e8b14a17aaace53a302e17f0f8162c90b13098277d874956dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e82343af2b7a75dc6acc0e94361fda04b031c273792e18f65af2d21ba21552d"
  end

  depends_on "ldc" => [:build, :test]
  depends_on "pkg-config"

  uses_from_macos "curl"

  def install
    ENV["GITVER"] = version.to_s
    system "ldc2", "-run", "./build.d"
    system "bin/dub", "scripts/man/gen_man.d"
    bin.install "bin/dub"
    man1.install Dir["scripts/man/*.1"]

    bash_completion.install "scripts/bash-completion/dub.bash" => "dub"
    zsh_completion.install "scripts/zsh-completion/_dub"
    fish_completion.install "scripts/fish-completion/dub.fish"
  end

  test do
    assert_match "DUB version #{version}", shell_output("#{bin}/dub --version")

    (testpath/"dub.json").write <<~EOS
      {
        "name": "brewtest",
        "description": "A simple D application"
      }
    EOS
    (testpath/"source/app.d").write <<~EOS
      import std.stdio;
      void main() { writeln("Hello, world!"); }
    EOS
    system "#{bin}/dub", "build", "--compiler=#{Formula["ldc"].opt_bin}/ldc2"
    assert_equal "Hello, world!", shell_output("#{testpath}/brewtest").chomp
  end
end
