class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "33f4dd226c5c49f781e73cb79bfadb927c1cafd0f28f0f769070dc10880fbf63"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ac6b23e2e5b71ef109fe7af1a81927da9150abe1311874aec91bd62cd360b46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f733cd64f26531f7291eb4580ea18c95250d81a713b5f41237791a4908580bc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3415ae4691696d33a090f6531cafe3926dab986c798feb153d409dc253003c56"
    sha256 cellar: :any_skip_relocation, sonoma:        "174c70bd789529e50b55e12699c8a40c6dc4b7979c5e9511170ff8041b063acd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54a5d5be098153bb5b3e5e64c626603ac3a8e66b14a327f361f4ceee4907f00f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "704e7efb5b0a78714326c5e02d59f44902b32ae2b84352c944113525451fded5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output("#{bin}/overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
