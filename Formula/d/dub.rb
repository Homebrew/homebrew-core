class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "f69ebd696d0e7c7d826fa835dc8594b20e62c475c0d7e60cfb2f342b4a5887b3"
  license "MIT"
  version_scheme 1
  compatibility_version 1
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
    manifest_sha256 "0c02e314d277357d598bb4b5eb7de47b1f1218e2f852db8e9ac5e1bc89040602"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2455cc59a797bc6f8c0701a702d2b7fbf8719d92a75b3faa645bdf104495082"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "762c179465207a6481448a33cb3adac12ce9253b20922bbf7add92ceb799a18a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b04324f5af0bec5ee837aced9d850bb063139004b878eb2a8596e16c1830926a"
    sha256 cellar: :any,                 arm64_linux:       "64fd3c0c6b296a1fdf1dae62b9ef696edeebb1bdcadbd6856f52c5663ba7091b"
    sha256 cellar: :any,                 x86_64_linux:      "d769f1ffcdfb649ee0514dc0f428afd5b56e2e7bf5d3c11304db43b4ae6ae312"
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
