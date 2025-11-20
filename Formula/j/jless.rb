class Jless < Formula
  desc "Command-line pager for JSON data"
  homepage "https://jless.io/"
  url "https://github.com/PaulJuliusMartinez/jless/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "43527a78ba2e5e43a7ebd8d0da8b5af17a72455c5f88b4d1134f34908a594239"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4b17c0b4b3fc59321e8ec683fb7811aac39c4e928191f18a48a6c5ebe0ef5cef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6227a6ccd685510fd4a4db69ac652e12b785dfb320afab4dfdced92ca546f6a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce76bc45d945ae9210c3ede829ae8dbf7087faffa41f8edd18887566aca9a944"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5950521cf007e81591e09fb2f7f2b85e704609fa7cf9aa035125343e2fc7657e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c870a901478c8084488d128b0baf7a3859e5d53b6cfcc048fe0418d96e1552"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef4ca6e6317cf02257759c994f95cb3a35aef960cb7abb2babd3c94f49eeff1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ec22c222b62c7e7439eff8d357a841aff831c1e544c58de3bf0c8d56ba32f45"
    sha256 cellar: :any_skip_relocation, ventura:        "5fd473bb7164c9c5ea0ce8695e0c1aa7976a7acf914455c3ddde42c24d3c25c4"
    sha256 cellar: :any_skip_relocation, monterey:       "d89da34d0330ce44f59bc97d83fff9c2e1851210587d1e5fa69b4b9d6ec784e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebeed1f09b8a73d3918d0123d2d9dbc26da31d40be642f6dc6a9d9d02a7ae972"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5dd5790c437fc0b474aaf0e9e2add485ebc5867d64955e99d72aa0920aaf0e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0502fb07b111d0bd0b5bb2983225e8f2e313329fd7dad6287aac989dac9f8e1"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build # for xcb < 0.10.0

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write('{"hello": "world"}')
    res, process = Open3.capture2("#{bin}/jless example.json")
    assert_equal("world", JSON.parse(res)["hello"])
    assert_equal(process.exitstatus, 0)
  end
end
