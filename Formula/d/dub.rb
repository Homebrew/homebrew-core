class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/refs/tags/v1.38.1.tar.gz"
  sha256 "a7c9a2f819fdea7359f298cba76e81a24ca1536d756c3b4b98c2480463c37907"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6eedaee85ac081a73d1c1a01e57a2965486aaa985a800511343b1300b7216574"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f744a26e8206a1f16fa722c1bd3e7c18419372f396a19270d9e53883a0b3af17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1819bc676849f4caa460cf225218e7e79e253d02aee9ccb5931142e509c87f94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e15b323b92be9d66f1f7f8ee81d578f287e1ab794f541a0968ec9db8c316fb13"
    sha256 cellar: :any_skip_relocation, sonoma:         "a44630a4b1e1e6a8b517fc642078244393c1e430981f5ecd7d9224a885e3c275"
    sha256 cellar: :any_skip_relocation, ventura:        "5deb452827fb0a42082117da2fddb2deae0d5d4bb805bb42170375c7d1bca3ab"
    sha256 cellar: :any_skip_relocation, monterey:       "a83dc23f27613cc5f5b9a87a6a5be610c2db72213dd50202f828fa212246a18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78bc68a073aa671f67b179de7520e563c7a936a7cdafd9b70e8b28ddb645e3fa"
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
    system bin/"dub", "build", "--compiler=#{Formula["ldc"].opt_bin}/ldc2"
    assert_equal "Hello, world!", shell_output("#{testpath}/brewtest").chomp
  end
end
