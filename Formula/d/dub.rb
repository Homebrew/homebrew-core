class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "db19791536f14701334893408864b38a3a22004b32a1e67d485c72cd80411ca4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "607bffdcae883a29e29ae76e865dfaaabffdea1d02ad00d32aaaf81c2ee36b74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad626c61d86ea009ef353d3c759fa0b6e801b10416ac61405b1d56a7bef41dc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0e8683fbada6301f6ccf23daf40ed6c9f5cb22682c7b21269989dfb348eafc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "cca7d912eed2371df18775195399f2518ca1eead588013d5010547efc5faf800"
    sha256 cellar: :any_skip_relocation, ventura:        "f1adff60f5933c4d24e66c30911e3b25acf168011f8e1bb5f90c028614f02b1c"
    sha256 cellar: :any_skip_relocation, monterey:       "a1d425abfe4a217a219a3114d66518693925be37abf2d8e8aa0f2457818984a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78dfacc614093a58864bf9651cdee15fe5ddef4ca1f3541944c27902ed28206d"
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
