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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d955e6574a5ee0e3e1a5d3921d6bb1f9edf4bfa866645adbfd263786c58e6375"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b32a6af7b3c734ef0b5e0084d3bb2b66e09262ba351404a592f626fd9d027847"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dbc1624e4313e95d94800d8015bd7c23957cf64a354af4add4c7e349c844b50"
    sha256 cellar: :any_skip_relocation, ventura:        "d94ef92e56886da1333be60bd335d8ed001a5bc85e6cc4eb115540539e2081d9"
    sha256 cellar: :any_skip_relocation, monterey:       "bec55a20482aa6a6c4a364ba4addc90efe9c25091ebf45e792e68e289feb6e3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e7817d0d879e9a96b9e14db78d16c6c5b4f6d8ed44e37061d16c59eb6fdb469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ad9a025ebe764f94dbc23116b68b6b10682d0ec4886c0d0663860203055841f"
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
