class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.29.2.tar.gz"
  sha256 "1526f5a2073205eeaf3fbbb62933f0e04bc452de82c0968dd90abba7baceaeea"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d55dd4437b993a784b11d770000b3f9d7b432c440b4e633b41b498a18fad01f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d4eef5c830a990cc47964aa66468360954c2f24563a1787d178655b35912cbe"
    sha256 cellar: :any_skip_relocation, monterey:       "cda296d526a9bc5122f2e7b09f15d70e91475abf5ccba33a4cf29cc4ac92b81d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2db41b9a8ef24687b432d2f3d2212b86212d51a383b7bf74c1800cfd827c2317"
    sha256 cellar: :any_skip_relocation, catalina:       "ec93dc4c92f36de1277c81394a861cba9564f8fa9826c432441162e484b4d89f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ef188bee3c040f6e74487fe46330af14fc9903f4847a8bef05833a6fc0dafd3"
  end

  depends_on "ldc" => :build
  depends_on "pkg-config"

  uses_from_macos "curl"

  def install
    ENV["GITVER"] = version.to_s
    system "ldc2", "-run", "./build.d"
    system "bin/dub", "scripts/man/gen_man.d"
    bin.install "bin/dub"
    man1.install Dir["scripts/man/*.1"]
    zsh_completion.install "scripts/zsh-completion/_dub"
    fish_completion.install "scripts/fish-completion/dub.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
