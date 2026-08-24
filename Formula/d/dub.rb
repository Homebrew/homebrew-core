class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "7f0a5133885a71b89f7a683d8f3e3616e070238424b36ae04fdbc0d7b99e3027"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4c2c13b0d370c4c67216140002dd1283391b6d5efbbae022e9cb9e1631199a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2debfa6562ba2f5a2364f0212411f6a99abb39f5c9498bf0ef6781ae25b9afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44e71aeb7048f8bfabfeee7d4b45c9fc0c3fc19db386479817bc05b71e0e044b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a830ab02e13c8fbbf99fbf9afc8e54f7a0620e03ca6defc99f9fd57193512df7"
    sha256 cellar: :any,                 arm64_linux:   "d3e39e08d0fe9c5a23c222f8e11afbeaf39a4c0328113c22755d797aa328d4eb"
    sha256 cellar: :any,                 x86_64_linux:  "d51f71b643fc4926e74ee1ca376a0b02ae5af630c963207aaccdd1fbaa3b1ca7"
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
    system bin/"dub", "build", "--compiler=#{formula_opt_bin("ldc")}/ldc2"
    assert_equal "Hello, world!", shell_output("#{testpath}/brewtest").chomp
  end
end
