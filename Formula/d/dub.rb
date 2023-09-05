class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.34.0.tar.gz"
  sha256 "970a33561310eb62a5494170e2a542f0c675952a18d4ba38a399449be0a8caff"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9302d04a5e60319a4230e279ae38268591f36c193e18cc0b5273a96ab542abc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a259d90297424bfe1f68d9e80484dcf225cfdcb7f3a87197765b3fde48ceadc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e65a0a2283f67292596fb33600a8b195d8a857a57df5200ffe35ca64a76f51a"
    sha256 cellar: :any_skip_relocation, ventura:        "aa631b2f9ace16645beeebabb135e8c8ead864b628066333b9acac7094e9a2a4"
    sha256 cellar: :any_skip_relocation, monterey:       "376a3247ce5f2d10406832349031a6952736c357a108b74fa5a3f20706f686f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac6dc1610e3dd3308aa9f15f1ad78adb031731d68f5b56df1292007d80ef9e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2842afb61abab0cf1835f723e3cc6b828458022eab6d079b412c725bbb93f84"
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
