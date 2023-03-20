class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.31.1.tar.gz"
  sha256 "dce1b3f7d21f6b111830d849e6f417853bab66d9036df212aec237c1f724bc4f"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb542fcbf6ddaec5b3d5c788add6653e4d6d9db3150e5dcbdf6296320ae482d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5b054a34d92dfdaba92707eb67c6e93b606452adcf42b4553cdbd0694cb1ea0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03b9179be706b9aac8b1941a05d54466d7d8a9f24fb33a51c9bffb0180705785"
    sha256 cellar: :any_skip_relocation, ventura:        "1faab36973c26f70f499cc43549e6adbb895b29c41443dbcf7c29803f0773d22"
    sha256 cellar: :any_skip_relocation, monterey:       "4fcca89c3bc1e7103c1783b4cb873e54e0201299529c66b57bd95329839f6428"
    sha256 cellar: :any_skip_relocation, big_sur:        "520a6d3e284ea9368e103eca031897581bee157b2f3a0cd0df867ca9329d8e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "677c684f31011e515eadf2f3c66abf96ea4b050e2e1a00906cca8e9dd7863371"
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
