class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "16ac09875889af03abeeca9b60777ee51611c86b3efe5869db3331d2fd97fd2b"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git", branch: "master"

  # Upstream may not create a GitHub release for tagged versions, so we check
  # the dlang.org package as an indicator that a version is released. The API
  # provides the latest version (https://code.dlang.org/api/packages/dub/latest)
  # but this is sometimes an unstable version, so we identify the latest stable
  # version from the package's version page.
  livecheck do
    url "https://code.dlang.org/packages/dub/versions"
    regex(%r{href=.*/packages/dub/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2486533fdb851821094b56a499dd8114babb5274c03c03cf7e13355469d9b13c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1908c7ce55d9a3f141cba7116312aa9bbfe60afd7935fd42b42ec34fa752cde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52533c8d84a78de2f2dde9f02ae69077fd7554975720d73a56758f88a1037f87"
    sha256 cellar: :any_skip_relocation, sonoma:         "9625976c2456eeaa47b162e87402be05f16caf570b25180bd9e27cbd57a19fce"
    sha256 cellar: :any_skip_relocation, ventura:        "ca8f9f0874c3490107a2aafec46d4f25788bd0ab4829d9842ea989d61257faac"
    sha256 cellar: :any_skip_relocation, monterey:       "888e3fd4c968b2c5991d98a0bdc5eedfc499c80a510149ef84f60da55acb962c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a47a4fefbd0c7201f7f66b89ee1b29c1854054e63146ae7c018ad54e8852705"
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
