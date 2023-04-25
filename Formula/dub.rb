class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.32.0.tar.gz"
  sha256 "a0ceaee069834388fec41d13f4df479d38f4e81b0de965adbff6e07e51c792e9"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e43e7499cf60f96f5571c9dbb9e16e5379d3273e2959c743aa49d29efabe3bf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "159ac881d54dad222146c1d95bbaa908da20f96b43d9cab7ad72b5c6fdfd9b1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9012bd28c6a189fa374697e55d6b521b785514a462621b62dca29717c0b755e8"
    sha256 cellar: :any_skip_relocation, ventura:        "ea50b79439b3136ad8170197af15f9c2e1aa2b73cda110c1621a857b84eca098"
    sha256 cellar: :any_skip_relocation, monterey:       "8901f6ec878edfd41dcf3a949b73ddc7aa340e38f1881b9ac0722a089871ac47"
    sha256 cellar: :any_skip_relocation, big_sur:        "88855f5ad9e6a62bdcc2ed6e97e0a032b18006794d3e8dc4a45b8956437e377a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4a0a2fde4f2649b63732d9b1c0425feebb941364ccd16a544391c86dd8d267a"
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
