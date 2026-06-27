class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.12.8.tar.gz"
  sha256 "46c1dc142fced092b2603a7ad6928c4fdefcefc753801ba593b77682e50dd275"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "816268b62b7fc3df8a306e076f472782deaf30437057e768ff63a9639ff04899"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5401430b01d8dc0ee925b0beb23fe5cc80147151eb13f410ebabcd46fd5565e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c0a2b363fc27c714480b92066e9c14d579f631f94b118a9d60c507c036879e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c52aa5668193571eac83df121acd32ea1b743997b1d971216b816e552c6bf6c"
    sha256 cellar: :any,                 arm64_linux:   "db4ccc00b6cdbb71c57c1148a5fcac78ab13293694e0a06f5347fe0d7156d9ea"
    sha256 cellar: :any,                 x86_64_linux:  "f203b5280a31ceacdfc692d24a95b77a325f2bad2be59031fe7fd6ce23eaaf97"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
