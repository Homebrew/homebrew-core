class Dutree < Formula
  desc "Tool to analyze file system usage written in Rust"
  homepage "https://github.com/nachoparker/dutree"
  url "https://github.com/nachoparker/dutree/archive/refs/tags/v0.2.18.tar.gz"
  sha256 "55c30e57cc339dd16141510af33245cc3b82f588f22419fc034f02b36ebecba0"
  license "GPL-3.0-only"
  head "https://github.com/nachoparker/dutree.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "7142809bdc97574f3eb01d7b910a6cb7ac6d177da3781c91516961ced6ac46f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "793482f753b7365d719641115e8e55714a4fc272385b7e387c4e68c4791991a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "235807c35ae72d2b7c0ce81eba444d8fa0db6dcc657deb5de876b58037dde646"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bbb961b815ddd2b4674a485740e9e5f19b7a135ad73e6631f0fcf4ddf78414a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaf7782638a422504bf3b733217e94eb8fc63cb09123d6a05bf566da56568a7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2b038d11a79c57d6b6b3e650b3499315856ab30621b163366ac42bdc22044c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "15d202fddeafd1e3fdbebfea5f690a3b8f045b54514e6652b9f11e988c412305"
    sha256 cellar: :any_skip_relocation, ventura:        "aaa311e0c04f6110ba51dd74d8f8315a7d720f1be65a77d7148a37d3248fdfa4"
    sha256 cellar: :any_skip_relocation, monterey:       "f36cc2121241cb577bbe53de7a0187e089ebc1e4c0bdce0cb0fbb2112f3e5eba"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bdb0ab41ee8863edc1f6bd4830065369e1b228114b27cd1d8aef35c10d46718"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "79d48c21002b537d1ab15cf2d22327221135301388802741e015ec14bb84a8c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ea01a9b842b4fe3709ad4a95e8e1ef9d8ac9118eab5bff07df7970f844c6417"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"brewtest"
    assert_match "brewtest", shell_output("#{bin}/dutree --usage #{testpath}")

    assert_match "dutree version #{version}", shell_output("#{bin}/dutree --version")
  end
end
