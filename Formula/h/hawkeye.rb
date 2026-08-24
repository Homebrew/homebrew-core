class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v7.0.0.tar.gz"
  sha256 "67331fbed422037948d4cd8aca005ec090ec0f07c946dd8d74cc0b089c7bd5bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7fc5e1656fe101ae4db82bf474a06304f353e057dc119d9c426da93329e462c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcf93e92517d279420fcbf8e42021ac1e558e7cda1b1ab28dc9404f9c5cb44eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "430ceb91cc9e9267a8dbfa45d791ef0cc20c2c89fb69d0d302d091f4e8b0b200"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf92aef38f43c41af9b4a14e2e7862f17b1c4c49a86b03820987dda99a0c7f78"
    sha256 cellar: :any,                 arm64_linux:   "7ff8ad148c6ff59d53b344bf33858ec8e27e3bd04c3c351312033f09dcdf524c"
    sha256 cellar: :any,                 x86_64_linux:  "87776345fe0f61d14ea226046df0276700c385fe8e38d4394b4faffdc29edee2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "hawkeye")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hawkeye --version")

    configfile = testpath/"licenserc.toml"
    configfile.write <<~TOML
      includes = ["licenserc.toml"]
    TOML

    assert_match "unknown field `includes`", shell_output("#{bin}/hawkeye format 2>&1", 2)
  end
end
