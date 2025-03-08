class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "cddca43c76c619487857ea13b3acaf1d7bfda4251e058f0ab61538c4bbb84820"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d4d3e520dab8665bd4cc4fcb9bfd35ce90bcea96e5332255772095c56c9ce0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b1262d5346b6f7103f71d5b5e2c0f48b8366fd0e63f89b2fb958c9d792e257d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f5a661ddced42a30f8c4665f984ab1b3e754921007dbdfee769c3d520e25d86"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e48bbe19cfac01102c4f6b5a1c29ac8cc961cc2551d3a7e809fff964ed4261e"
    sha256 cellar: :any_skip_relocation, ventura:       "d27e8cb27b68587060d1c63a4e124a39ca5a3e4704ac40118d481646244d3440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0bd12f64c42e34983e753649feb1168ddaba5418e6a8b487fefa48bb68c0404"
  end

  depends_on "ldc" => [:build, :test]
  depends_on "pkgconf"

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

    (testpath/"dub.json").write <<~JSON
      {
        "name": "brewtest",
        "description": "A simple D application"
      }
    JSON
    (testpath/"source/app.d").write <<~D
      import std.stdio;
      void main() { writeln("Hello, world!"); }
    D
    system bin/"dub", "build", "--compiler=#{Formula["ldc"].opt_bin}/ldc2"
    assert_equal "Hello, world!", shell_output("#{testpath}/brewtest").chomp
  end
end
