class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.12.3.tar.gz"
  sha256 "94e23af5f246f033d26141743012a47561f14cebaca2734a615fa5f0ef00ede9"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b35c989a9028c2e0367dfc0c5e6e4b703409f7dbba7ef072f2e0ee05ae546196"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "610c744cb3f5654172d3d1c023867b5b730dfb6dafd83cb53468b877c89bb4b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4418b3121568e8081c5e59762a2c822cdca85148bc96046523b128383c95ec7"
    sha256 cellar: :any_skip_relocation, sonoma:        "78c64b9ce650221108758fbc4977d9f8b86ab7baf84d3791d8bb88741a954e77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7262d686702ef166bd0dc1a6458eaf6c043335bae39eec9066775b996cfd5959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21c4247220728189292a3af33bfd8013743ebea0e2ddff471f63bc375a1086b3"
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
