class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "3376d15c740d8e6f02a9e5d388bb7e5d4ffccf2ae8e386e5b2839a22221afb2f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14e5c58fae52a4fe7de9f0bb1c9d277178513b1528ca339550bec833abd5343f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "948ed009ea10b96767305f5ac498277b265366278dd7137f0b4aae139ce2c01c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b836f2cafaa560121c7ef603b0c7a9eb8ec543f0b80f2f0b326bc0737e788718"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba184d2c4039bb02bcc5908d55e1138c4260ac7ab755266f39058100454fc9a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35d4bf7abf381b325283caaa3faff5f111ea8c1569a19e148455a3f02e0aef94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f5bf9ce785be7215f80822c4d58da0ead701e3a89f08c4f4d2d243de2f7fe48"
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
